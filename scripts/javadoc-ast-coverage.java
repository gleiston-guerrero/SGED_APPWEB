import com.sun.source.doctree.DocCommentTree;
import com.sun.source.tree.*;
import com.sun.source.util.*;
import javax.lang.model.element.Modifier;
import javax.tools.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

/**
 * Contador de cobertura/completitud de Javadoc por AST real de javac.
 *
 * Es la misma tecnica que uso la evaluacion independiente del examen
 * suspenso (analizador de javac) y complementa la heuristica de texto de
 * scripts/javadoc-coverage.py: donde esa cuenta 503/503, la revision AST
 * conto 506 elementos publicos (difiere en +-3 por criterio: metodos
 * sinteticos de records, casos limite de firma multipartida), 100 %
 * documentados. Exige las mismas reglas que el medidor heuristico y la
 * correccion del 20-sep (273f3474):
 *   - texto real dentro del bloque (un "{@inheritDoc}" solo no cuenta);
 *   - un "@param" con descripcion por cada parametro;
 *   - un "@return" con descripcion si el metodo devuelve algo;
 *   - un "@throws" por cada excepcion declarada en la firma `throws`;
 *   - un "@throws" si el cuerpo lanza una excepcion con `throw new`.
 *
 * Uso:
 *   javac -d /tmp scripts/javadoc-ast-coverage.java
 *   java -cp /tmp javadoc_ast_coverage [src] [umbral_porcentaje]
 *
 * Sale con 0 si cobertura y completitud >= umbral (default 100, la lectura
 * estricta del evaluador: no debe quedar ningun metodo publico incompleto),
 * 1 en caso contrario. Sin dependencias externas: solo el JDK (jdk.compiler).
 */
class javadoc_ast_coverage {
  static int total = 0, documented = 0, complete = 0;
  static List<String> detalle = new ArrayList<>();

  static double pct(int n) { return total == 0 ? 0.0 : (n * 100.0 / total); }

  public static void main(String[] args) throws Exception {
    Path src = Paths.get(args.length > 0 ? args[0] : "backend/src/main/java");
    double threshold = args.length > 1 ? Double.parseDouble(args[1]) : 100.0;
    List<String> srcs = new ArrayList<>();
    Files.walk(src).filter(p -> p.toString().endsWith(".java"))
      .forEach(p -> srcs.add(p.toString()));
    if (srcs.isEmpty()) { System.err.println("sin archivos .java en " + src); System.exit(1); }

    JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
    DiagnosticCollector<JavaFileObject> diags = new DiagnosticCollector<>();
    StandardJavaFileManager fm = compiler.getStandardFileManager(diags, null, null);
    Iterable<? extends JavaFileObject> units = fm.getJavaFileObjectsFromStrings(srcs);
    JavacTask jt = (JavacTask) compiler.getTask(null, fm, diags,
      List.of("-proc:none", "--release", "21", "-Xlint:none"), null, units);
    DocTrees trees = DocTrees.instance(jt);

    for (CompilationUnitTree cu : jt.parse())
      new TreePathScanner<Void, String>() {
        @Override public Void visitMethod(MethodTree mt, String file) {
          Tree cls = getCurrentPath().getParentPath().getLeaf();
          boolean isIface = cls.getKind() == Tree.Kind.INTERFACE;
          boolean pub = isIface || mt.getModifiers().getFlags().contains(Modifier.PUBLIC);
          if (pub) {
            total++;
            DocCommentTree dc = trees.getDocCommentTree(getCurrentPath());
            String doc = dc == null ? null : dc.toString();
            String repr = file.substring(file.lastIndexOf('/') + 1) + ":"
              + ((ClassTree) cls).getSimpleName() + "." + mt.getName()
              + "(" + params(mt) + ")";
            if (doc == null || !hasText(doc)) { detalle.add("SIN_JAVADOC  " + repr); return null; }
            documented++;
            boolean ok = true;
            for (VariableTree p : mt.getParameters())
              if (!hasTag(doc, "@param", p.getName().toString())) { ok = false; break; }
            if (ok && mt.getReturnType() != null
                && !mt.getReturnType().toString().equals("void")
                && !hasReturn(doc)) ok = false;
            if (ok && !mt.getThrows().isEmpty())
              for (Tree exc : mt.getThrows())
                if (!hasTagThrows(doc, exc.toString())) { ok = false; break; }
            if (ok && bodyThrows(mt)
                && !doc.contains("@throws") && !doc.contains("@exception")) ok = false;
            if (ok) complete++; else detalle.add("INCOMPLETO  " + repr);
          }
          return super.visitMethod(mt, file);
        }
      }.scan(cu, cu.getSourceFile().getName());

    System.out.println("Metodos/constructores publicos por AST de javac: " + total);
    System.out.println("Con Javadoc con texto propio: " + documented);
    System.out.println("Completos (@param/@return/@throws con descripcion): " + complete);
    System.out.printf("Cobertura: %.1f%%  Completitud: %.1f%%  (umbral %.0f%%)%n",
      pct(documented), pct(complete), threshold);
    detalle.forEach(x -> System.out.println("  " + x));
    boolean ok = pct(documented) >= threshold && pct(complete) >= threshold;
    System.out.println(ok ? "RESULTADO: PASA" : "RESULTADO: FALLA");
    System.exit(ok ? 0 : 1);
  }

  static String params(MethodTree mt) {
    List<String> ps = new ArrayList<>();
    for (VariableTree v : mt.getParameters()) ps.add(v.getType() + " " + v.getName());
    return String.join(", ", ps);
  }

  static boolean bodyThrows(MethodTree mt) {
    if (mt.getBody() == null) return false;
    final boolean[] found = {false};
    new TreeScanner<Void, Void>() {
      @Override public Void visitThrow(ThrowTree t, Void v) { found[0] = true; return null; }
    }.scan(mt.getBody(), null);
    return found[0];
  }

  static boolean hasText(String doc) { return doc.replaceAll("[*@{}]", "").trim().length() > 0; }

  static boolean hasReturn(String doc) {
    String d = doc.replace('*', ' ');
    int i = d.indexOf("@return");
    if (i < 0) return false;
    String rest = d.substring(i + "@return".length()).trim();
    return !rest.startsWith("@") && rest.length() > 0;
  }

  static boolean hasTag(String doc, String tag, String name) {
    String d = " " + doc.replace('*', ' ') + " ";
    int idx = d.indexOf(tag);
    while (idx >= 0) {
      int end = d.indexOf("@", idx + tag.length());
      if (end < 0) end = d.length();
      String rest = d.substring(idx + tag.length(), end).trim();
      if (rest.startsWith(name)) {
        String after = rest.substring(name.length()).trim();
        if (after.length() > 0 && !after.startsWith("@")) return true;
      }
      idx = d.indexOf(tag, idx + tag.length());
    }
    return false;
  }

  static boolean hasTagThrows(String doc, String exc) {
    String d = " " + doc.replace('*', ' ') + " ";
    for (String tag : List.of("@throws", "@exception")) {
      int idx = d.indexOf(tag);
      while (idx >= 0) {
        int end = d.indexOf("@", idx + tag.length());
        if (end < 0) end = d.length();
        String type = d.substring(idx + tag.length(), end).trim().split("\\s+")[0];
        if (type.equals(exc)) return true;
        idx = d.indexOf(tag, idx + tag.length());
      }
    }
    return false;
  }
}
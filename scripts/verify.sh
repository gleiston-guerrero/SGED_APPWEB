#!/usr/bin/env bash
# EV-2 (Guia del examen suspenso, UTEQ Aplicaciones Web): comprobacion
# automatica de los 14 pendientes de la guia, mas una guarda de regresion
# sobre los 12 puntos que la guia ya da por resueltos (seccion 1: "si al
# cerrar un pendiente rompen algo de esta lista, ese punto deja de estar
# resuelto"). Pensado para correr desde un clon limpio con `make verify`.
#
# Cada punto imprime PASA / FALLA / PENDIENTE (manual) y por que. El codigo
# de salida es 0 solo si todos los puntos automatizables pasan.
set -uo pipefail
cd "$(dirname "$0")/.."

FAIL=0
PASS_COUNT=0
FAIL_COUNT=0
MANUAL_COUNT=0

pass() { echo "  PASA: $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo "  FALLA: $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); FAIL=1; }
manual() { echo "  PENDIENTE (revision manual): $1"; MANUAL_COUNT=$((MANUAL_COUNT + 1)); }
section() { echo; echo "== $1 =="; }

# ---------------------------------------------------------------------
section "P1 -- SUS: respuestas reales, Brooke, IC con t de Student"
n_resp=$(($(wc -l < docs/mediciones/sus/respuestas.csv) - 1))
if [ "$n_resp" -ge 15 ]; then pass "respuestas.csv tiene $n_resp participantes (>=15)"; else fail "respuestas.csv tiene $n_resp participantes (<15)"; fi
# (Corrección 2026-09-17, evaluación integral: contar lineas no distingue
# 15 respuestas reales de 15 filas basura -- ">=15" pasa igual con
# cualquier contenido. Valida forma: 21 columnas, participante ENC-NN,
# p1..p10 enteros 1-5.)
csv_errores=$(python3 - docs/mediciones/sus/respuestas.csv <<'PYEOF'
import csv, re, sys
ruta = sys.argv[1]
with open(ruta, newline='', encoding='utf-8') as f:
    filas = list(csv.reader(f))
cabecera = filas[0]
esperado = 21
errores = []
for fila in filas[1:]:
    if len(fila) != esperado:
        errores.append(f"{fila[0] if fila else '?'}: {len(fila)} columnas, se esperaban {esperado}")
        continue
    d = dict(zip(cabecera, fila))
    problemas = []
    if not re.fullmatch(r'ENC-\d+', d.get('participante', '')):
        problemas.append('id no tiene forma ENC-NN')
    for p in [f'p{i}' for i in range(1, 11)]:
        v = d.get(p, '')
        if not (v.isdigit() and 1 <= int(v) <= 5):
            problemas.append(f"{p} fuera de rango 1-5")
            break
    if problemas:
        errores.append(f"{d.get('participante', '?')}: {', '.join(problemas)}")
print(f"{len(errores)} fila(s): " + '; '.join(errores[:5]) + (' ...' if len(errores) > 5 else '') if errores else '')
sys.exit(1 if errores else 0)
PYEOF
)
if [ -z "$csv_errores" ]; then
    pass "respuestas.csv: filas bien formadas (21 columnas, ENC-NN, p1..p10 en 1-5)"
else
    fail "respuestas.csv con filas mal formadas: $csv_errores"
fi
if grep -qi "brooke" docs/mediciones/sus/REPORT.md 2>/dev/null; then pass "REPORT.md cita a Brooke (1996)"; else fail "REPORT.md no cita a Brooke"; fi
if grep -qi "t de Student" docs/mediciones/sus/REPORT.md 2>/dev/null; then pass "REPORT.md calcula el IC con t de Student"; else fail "REPORT.md no documenta el metodo del IC"; fi
echo "  Nota: P1 tambien exige consentimiento de cada participante -- ver P13."

# ---------------------------------------------------------------------
section "P2 -- Lighthouse: 3 corridas por perfil contra el despliegue publico"
# (Corrección 2026-09-16: antes contaba mobile-run*/desktop-run*, que son
# locales (host.docker.internal), mientras REPORT.md hablaba del despliegue
# público. Ahora se exige requestedUrl = despliegue vigente dentro del JSON.)
R2RS="https://sged-frontend-r2rs.onrender.com/"
# (Corrección 2026-09-17, evaluación integral: exigir ">=3 validas" no
# detecta si alguien cambia el requestedUrl de UN archivo a localhost --
# con 9+9 corridas archivadas, sobran de sobra para seguir pasando el
# umbral de 3 aunque una este corrompida. Ahora se exige que TODAS las
# corridas encontradas sean validas, ademas del minimo de 3.)
mobile_runs=0; mobile_total=0; mobile_malas=""
for f in docs/mediciones/lighthouse/public-mobile-*.report.json; do
    [ -f "$f" ] || continue
    mobile_total=$((mobile_total + 1))
    if python3 -c "import json,sys;sys.exit(0 if json.load(open('$f',encoding='utf-8')).get('requestedUrl','').startswith('$R2RS') else 1)" 2>/dev/null; then
        mobile_runs=$((mobile_runs + 1))
    else
        mobile_malas="$mobile_malas $f"
    fi
done
desktop_runs=0; desktop_total=0; desktop_malas=""
for f in docs/mediciones/lighthouse/public-desktop-*.report.json; do
    [ -f "$f" ] || continue
    desktop_total=$((desktop_total + 1))
    if python3 -c "import json,sys;sys.exit(0 if json.load(open('$f',encoding='utf-8')).get('requestedUrl','').startswith('$R2RS') else 1)" 2>/dev/null; then
        desktop_runs=$((desktop_runs + 1))
    else
        desktop_malas="$desktop_malas $f"
    fi
done
if [ "$mobile_runs" -ge 3 ] && [ "$mobile_runs" -eq "$mobile_total" ] && [ "$desktop_runs" -ge 3 ] && [ "$desktop_runs" -eq "$desktop_total" ]; then
    pass "$mobile_runs/$mobile_total corridas moviles + $desktop_runs/$desktop_total de escritorio con requestedUrl=$R2RS (todas validas)"
else
    fail "$mobile_runs/$mobile_total moviles + $desktop_runs/$desktop_total escritorio con requestedUrl publica vigente (se exige >=3 Y todas validas; invalidas:$mobile_malas$desktop_malas)"
fi
if grep -q "sged-frontend-r2rs.onrender.com" docs/mediciones/lighthouse/REPORT.md 2>/dev/null; then
    pass "REPORT.md documenta la medición vigente contra r2rs"
else
    fail "REPORT.md no documenta la medición contra r2rs"
fi

# ---------------------------------------------------------------------
section "P3 -- DOI declarados resuelven (excepto el retirado, documentado)"
if bash scripts/check-doi.sh; then pass "todos los DOI resuelven segun lo esperado"; else fail "algun DOI no resuelve como se espera"; fi

# ---------------------------------------------------------------------
section "P4 -- Javadoc de metodos publicos >=90%"
if python3 scripts/javadoc-coverage.py 90; then pass "cobertura de Javadoc >=90%"; else fail "cobertura de Javadoc <90%"; fi

# ---------------------------------------------------------------------
section "P5 -- validate-traceability.sh propaga el codigo de salida"
# Guarda real: valida docs/trazabilidad/matriz.csv tal cual esta en el
# repositorio (sin copias ni filas inyectadas). Sin esta linea, verify.sh
# nunca mira el archivo real -- solo probaba que el validador SABE
# detectar filas rotas en copias sinteticas, no que make verify falle si
# la matriz real se rompe (hallazgo de la evaluacion integral del 17-sep).
salida_real="$(bash scripts/validate-traceability.sh 2>&1)"
if [ $? -eq 0 ]; then
    pass "docs/trazabilidad/matriz.csv (la matriz real) valida sin violaciones"
else
    fail "docs/trazabilidad/matriz.csv (la matriz real) tiene violaciones: $(printf '%s\n' "$salida_real" | grep -m1 'VIOLACIÓN' || printf '%s\n' "$salida_real" | tail -1)"
fi

# Ruptura real: copia temporal de la matriz con una fila sin trazabilidad.
# (Corrección 2026-09-16: antes se pasaban rutas inexistentes, lo que solo
# probaba el manejo de archivos faltantes, no la validación de contenido.)
TMP_P5="$(mktemp -d)"
trap 'rm -rf "$TMP_P5"' EXIT
cp docs/trazabilidad/matriz.csv "$TMP_P5/rota.csv"
echo 'RF-DEMOSTRACION,CRUD-ORM,fila deliberadamente sin trazabilidad,,,GET /api/nada,backend/Nada.java,,,Planificado,' >> "$TMP_P5/rota.csv"
salida_p5="$(bash scripts/validate-traceability.sh "$TMP_P5/rota.csv" 2>&1)"; codigo_p5=$?
if [ "$codigo_p5" -eq 0 ]; then
    fail "el validador acepto una fila sin trazabilidad (deberia fallar)"
elif printf '%s\n' "$salida_p5" | grep -q 'VIOLACIÓN: RF-DEMOSTRACION'; then
    pass "el validador imprime la VIOLACIÓN y sale con codigo $codigo_p5 ante fila rota real"
else
    fail "el validador fallo pero no imprimio la VIOLACIÓN esperada"
fi
if [ -f scripts/test-validate-traceability.sh ] && bash scripts/test-validate-traceability.sh >/dev/null 2>&1; then
    pass "scripts/test-validate-traceability.sh (autotest de regresion) pasa"
else
    fail "scripts/test-validate-traceability.sh falla"
fi

# ---------------------------------------------------------------------
section "P6 -- Rotulado de figuras en ingles"
SPANISH_WORDS='Estudiante|Entrenador|Categoria|Asistencia|Evaluacion|Pago|Usuario|Persona|Articulo|Movimiento|Asignacion|Lesion|Partido|Notificacion|Consentimiento|Auditoria|Horario|Alineacion|Posicion|Especialidad|Representante|Alumno|Equipo|Jugador|Entrenamiento|nombre|apellido|correo|telefono|activo|fecha|estado'
hits=""
for f in docs/diagramas/*.md; do
    block=$(sed -n '/```mermaid/,/```/p' "$f" 2>/dev/null)
    m=$(echo "$block" | grep -noE "\b(${SPANISH_WORDS})\b" || true)
    if [ -n "$m" ]; then hits="$hits\n$f: $m"; fi
done
for f in docs/diagramas/*.svg; do
    m=$(grep -oE '<text[^>]*>[^<]*</text>' "$f" 2>/dev/null | grep -noE "\b(${SPANISH_WORDS})\b" || true)
    if [ -n "$m" ]; then hits="$hits\n$f: $m"; fi
done
if [ -f docs/arquitectura/workspace.dsl ]; then
    m=$(grep -noE "\"[^\"]*\b(${SPANISH_WORDS})\b[^\"]*\"" docs/arquitectura/workspace.dsl || true)
    if [ -n "$m" ]; then hits="$hits\ndocs/arquitectura/workspace.dsl: $m"; fi
fi
if [ -z "$hits" ] || [ "$hits" = "" ]; then
    pass "sin coincidencias del diccionario de terminos en español dentro de mermaid/svg/dsl"
else
    fail "coincidencias encontradas:$(echo -e "$hits")"
fi
manual "los PNG de docs/arquitectura/ y mer-profutbol.png son texto rasterizado -- no se puede grepear; confirmar a simple vista que coinciden con sus fuentes (ya en ingles)"

# ---------------------------------------------------------------------
section "P7 -- SRS firmado, versionado y con MoSCoW"
# (Corrección 2026-09-17, evaluación integral: un conteo global ">0" no
# detecta que a UN requisito puntual le falte el MoSCoW -- sigue habiendo
# 79 lineas "MoSCoW:" en vez de 80 y el chequeo global seguía pasando.
# Ahora se verifica requisito por requisito: cada encabezado RF-/RNF-
# debe tener su propia linea MoSCoW antes del siguiente encabezado,
# salvo los contenedores declarados que agrupan sub-items con letra
# -- RF-19 y RNF-23, ver SRS.md lineas 695 y 1602.)
moscow_faltantes=$(python3 - docs/requisitos/SRS.md <<'PYEOF'
import re, sys
texto = open(sys.argv[1], encoding="utf-8").read().splitlines()
CONTENEDORES = {"RF-19", "RNF-23"}
encabezado_re = re.compile(r'^\*\*((?:RF|RNF)-\d+[a-z]?) — ')
posiciones = [(i, m.group(1)) for i, l in enumerate(texto) if (m := encabezado_re.match(l))]
faltantes = []
for idx, (i, rid) in enumerate(posiciones):
    if rid in CONTENEDORES:
        continue
    fin = posiciones[idx + 1][0] if idx + 1 < len(posiciones) else len(texto)
    bloque = texto[i:fin]
    if not any("MoSCoW:" in l for l in bloque):
        faltantes.append(rid)
print(f"{len(posiciones) - len(CONTENEDORES)} requisitos evaluables (excluye {len(CONTENEDORES)} contenedores); faltan MoSCoW: {faltantes}")
sys.exit(1 if faltantes else 0)
PYEOF
)
moscow_codigo=$?
echo "  $moscow_faltantes"
if [ "$moscow_codigo" -eq 0 ]; then
    pass "cada requisito individual del SRS trae su propio MoSCoW explicito"
else
    fail "hay requisitos sin MoSCoW individual -- ver arriba"
fi
# (Corrección 2026-09-17: antes se comprobaba solo que existiera el acta
# de la v1.8, ya superada -- pasaba aunque la version vigente del SRS
# (declarada en su propia cabecera) no tuviera firma propia. Ahora se
# lee la version vigente del SRS y se busca el acta con ese nombre
# exacto: en cuanto el docente firme la version actual y su PDF se
# suba con el nombre ACTA-APROBACION-SRS-v<version>.pdf, este chequeo
# pasa a PASA sin tocar el script otra vez.)
srs_version=$(grep -oE 'Versión del documento:\*\* [0-9]+\.[0-9]+' docs/requisitos/SRS.md | grep -oE '[0-9]+\.[0-9]+')
acta_vigente="docs/requisitos/ACTA-APROBACION-SRS-v${srs_version}.pdf"
if [ -n "$srs_version" ] && [ -f "$acta_vigente" ]; then
    pass "acta de aprobacion firmada por el docente-director existe para la version vigente del SRS (v$srs_version)"
else
    acta_mas_reciente=$(ls docs/requisitos/ACTA-APROBACION-SRS-v*.pdf 2>/dev/null | sort -V | tail -1)
    fail "falta $acta_vigente (version vigente del SRS declarada en su cabecera: v${srs_version:-?}); la firma mas reciente que existe es de una version anterior ($acta_mas_reciente) -- ver P7 en VERIFICACION.md"
fi
if [ -f "docs/requisitos/SRS-v1.1.0.pdf" ]; then
    pass "docs/requisitos/SRS-v1.1.0.pdf existe"
else
    fail "falta docs/requisitos/SRS-v1.1.0.pdf (existe SRS-v1.0.0.pdf; falta republicar con el nombre v1.1.0 sobre el commit a defender)"
fi

# ---------------------------------------------------------------------
section "P8 -- una sola etiqueta v1.1.0 sobre el commit a defender"
if git rev-parse -q --verify "refs/tags/v1.1.0" >/dev/null; then
    pass "la etiqueta v1.1.0 existe, apunta al commit $(git rev-parse --short 'v1.1.0^{commit}')"
else
    fail "la etiqueta v1.1.0 no existe todavia"
fi
if grep -qE "^version:\s*1\.1\.0" CITATION.cff 2>/dev/null; then pass "CITATION.cff declara version: 1.1.0"; else fail "CITATION.cff no declara version: 1.1.0"; fi
# (Corrección 2026-09-17, evaluación integral: el chequeo anterior solo
# confirmaba que v1.1.0 existe, nunca que fuera la UNICA etiqueta activa
# que compite por ser "el corte que revisa el docente" -- crear una
# segunda etiqueta cualquiera pasaba sin que nada lo notara. Ahora se
# enumeran todas las etiquetas del repo y se falla si aparece alguna que
# no esté en la lista de historicas ya declaradas y retiradas de
# VERSIONING.md.)
ETIQUETAS_ESPERADAS="v0.1.0-entrega-1b v0.7.1 v0.9.0-rc v1.0.0 v1.0.0-previo-07sep v1.1.0"
etiquetas_reales=$(git tag -l | sort)
inesperadas=""
for t in $etiquetas_reales; do
    case " $ETIQUETAS_ESPERADAS " in
        *" $t "*) ;;
        *) inesperadas="$inesperadas $t" ;;
    esac
done
if [ -z "$inesperadas" ]; then
    pass "no hay etiquetas inesperadas -- solo $(echo $etiquetas_reales | tr ' ' ',')"
else
    fail "etiqueta(s) inesperada(s), no declarada(s) en VERSIONING.md:$inesperadas"
fi

# ---------------------------------------------------------------------
section "P9 -- nombres de tipos en espanol <=5%"
total_types=$(grep -rhoE '^\s*(public\s+)?(final\s+|abstract\s+)?(class|interface|enum|record)\s+\w+' backend/src/main/java --include=*.java 2>/dev/null | grep -oE '\w+$' | sort -u | wc -l)
TYPE_SPANISH_WORDS='Estudiante|Entrenador|Categoria|Asistencia|Evaluacion|Pago|Usuario|Persona|Rol[A-Z]|Articulo|Movimiento|Asignacion|Lesion|Partido|Notificacion|Consentimiento|Auditoria|Horario|Alineacion|Posicion|Especialidad|Estado[A-Z]|Representante|Alumno|Deporte|Equipo|Jugador|Entrenamiento'
spanish_types=$(grep -rlE "^\s*(public\s+)?(final\s+|abstract\s+)?(class|interface|enum|record)\s+\w*(${TYPE_SPANISH_WORDS})\w*" backend/src/main/java --include=*.java 2>/dev/null | wc -l)
pct=$(python3 -c "print(f'{($spanish_types / $total_types * 100) if $total_types else 0:.1f}')")
echo "  $spanish_types de $total_types tipos ($pct%) coinciden con el diccionario de terminos en español"
if python3 -c "exit(0 if $spanish_types / $total_types * 100 <= 5.0 else 1)" 2>/dev/null; then
    pass "$pct% <= 5%"
else
    fail "$pct% > 5%"
fi
manual "diccionario heuristico de 274 tipos -- un vistazo rapido a la lista completa cierra la duda con certeza frente al 32/277 (11,6%) que reporta la guia"

# ---------------------------------------------------------------------
section "P10 -- roles CRediT con conteo real por rol"
if grep -q "Funding acquisition" CONTRIBUTORS.md 2>/dev/null; then
    pass "los 14 roles CRediT estan cubiertos en CONTRIBUTORS.md"
else
    fail "CONTRIBUTORS.md no cubre los 14 roles CRediT"
fi
if [ -f scripts/credit-counts.py ] && grep -q "Conteo por rol (metodolog" CONTRIBUTORS.md 2>/dev/null; then
    pass "CONTRIBUTORS.md documenta el conteo por rol con script reproducible (scripts/credit-counts.py)"
else
    fail "falta el conteo por rol reproducible en CONTRIBUTORS.md"
fi
# (Corrección 2026-09-17, evaluación integral: ninguna de las dos
# comprobaciones de arriba nota si la tabla resumen "Integrante | Roles"
# se desincroniza de la tabla "Rol CRediT | Integrante(s)" que trae los
# conteos reales -- paso exactamente eso: a Arcalle le faltaba
# "Writing - review & editing" con el conteo mas alto de los tres.
# Ahora se cruzan ambas tablas.)
p10_incoherencias=$(python3 - CONTRIBUTORS.md <<'PYEOF'
import re, sys
texto = open(sys.argv[1], encoding="utf-8").read()
ALIAS = {"Darwin": "Arcalle", "Alejandro": "Pallo", "Ricardo": "Velez"}

# Tabla resumen: | Integrante | Correo | Roles (CRediT) |
resumen = {}
for m in re.finditer(r'^\| ([\w ]+ [\w ]+) \| ([\w.@-]+) \| ([^|]+) \|$', texto, re.M):
    nombre, _correo, roles = m.groups()
    resumen[nombre.strip()] = {r.strip() for r in roles.split(',')}

def nombre_completo(alias_corto):
    clave = ALIAS.get(alias_corto, alias_corto)
    for nombre in resumen:
        if clave in nombre:
            return nombre
    return None

# Tabla de conteo: | Rol CRediT | Integrante(s) | Cobertura |
incoherencias = []
tabla_rol = re.search(r'\| Rol CRediT \| Integrante\(s\) \| Cobertura \|\n\|---\|---\|---\|\n(.*?)\n\n', texto, re.S)
if not tabla_rol:
    print("no se encontro la tabla 'Rol CRediT' en CONTRIBUTORS.md")
    sys.exit(1)
for linea in tabla_rol.group(1).splitlines():
    m = re.match(r'\| ([^|]+) \| ([^|]+) \|', linea)
    if not m:
        continue
    rol, integrantes = m.group(1).strip(), m.group(2).strip()
    if integrantes == '—':
        continue
    for tok in integrantes.split(','):
        alias = re.match(r'\s*([A-Za-zÁÉÍÓÚñ]+)', tok)
        if not alias:
            continue
        nombre = nombre_completo(alias.group(1))
        if nombre is None:
            incoherencias.append(f"{rol}: no se pudo mapear '{alias.group(1)}' a un integrante de la tabla resumen")
        elif rol not in resumen.get(nombre, set()):
            incoherencias.append(f"{nombre} tiene conteo de '{rol}' pero no aparece en su lista de roles")
print('; '.join(incoherencias))
sys.exit(1 if incoherencias else 0)
PYEOF
)
if [ -z "$p10_incoherencias" ]; then
    pass "la tabla resumen de roles coincide con la tabla de conteo real (sin roles con conteo > 0 ausentes de la lista de alguien)"
else
    fail "tabla resumen desincronizada de la tabla de conteo: $p10_incoherencias"
fi

# ---------------------------------------------------------------------
section "P11 -- .env.example sin claves con aspecto real"
jwt_line=$(grep "^JWT_SECRET=" .env.example 2>/dev/null || echo "")
if echo "$jwt_line" | grep -qiE "cambiar|changeme|change_me|tu_|your_|placeholder|xxx|<.*>"; then
    pass ".env.example: JWT_SECRET usa un marcador evidente"
else
    fail ".env.example: JWT_SECRET ('$jwt_line') no tiene aspecto de marcador"
fi

# ---------------------------------------------------------------------
section "P12 -- una sola cifra de umbral de cobertura en todo el entregable"
# (Corrección 2026-09-16: antes solo revisaba main.tex y README y no
# reconocía el formato LaTeX 60\,\%. Ahora barre todos los archivos de
# texto versionados, reconoce 60 % / 60\% / 60\,\% / 0.60 / 0,60, y
# excluye únicamente los contextos históricos explícitos: la cita de la
# observación original en OBSERVACIONES.md, las notas de corrección que
# explican que el 60 % sí fue el valor configurado pero solo entre
# 2026-07-07 y 2026-08-14 (ya no "nunca fue el valor configurado" --
# esa frase era falsa, corregida el 2026-09-17), y los documentos
# anotados como históricos. docs/informe-entrega-3.pdf no se revisa
# -- ningún .pdf lo está, ver la nota de P12 en VERIFICACION.md -- por
# lo que sus menciones de "mínimo de 60 %" (artefacto congelado de la
# Tercera Entrega, sin fuente LaTeX versionada para regenerarlo) quedan
# fuera de esta comprobación automática por diseño, no por descuido.)
pom_threshold=$(grep -oE '<minimum>0\.[0-9]+</minimum>' backend/pom.xml | sort -u)
stray=$(git grep -n -E 'COVEREDRATIO\s*>=\s*0\.60|umbral[^.]{0,60}(60|0[.,]60)\s*(\\?,\s*\\?%|%)|(60|0[.,]60)\s*(\\?,\s*\\?%|%)[^.]{0,60}umbral|≥\s*60\s*%|>=?\s*0\.60' -- ':!docs/observaciones/OBSERVACIONES.md' ':!docs/superpowers/specs/2026-08-12-inventario-design.md' . 2>/dev/null | grep -vE '70\s*(\\?,\s*\\?%|%)|vigente|nunca fue el valor|históri|umbral actual' || true)
echo "  umbral en pom.xml: $pom_threshold"
if [ -z "$stray" ]; then
    pass "ninguna afirmación viva de umbral distinto de 70% en el repo versionado"
else
    fail "menciones de umbral con otra cifra: $stray"
fi

# ---------------------------------------------------------------------
section "P13 -- consentimientos informados del SUS, uno por participante"
REGISTRO=docs/etica/consentimiento/registro.md
if [ ! -f "$REGISTRO" ]; then
    fail "no existe $REGISTRO"
else
    filas=$(grep -cE '^\| ENC-' "$REGISTRO")
    pendientes=$(grep -cE '^\| ENC-[0-9]+ \|[^|]*\|[^|]*\| PENDIENTE \|' "$REGISTRO")
    obtenidos=$(grep -cE '^\| ENC-[0-9]+ \|[^|]*\|[^|]*\| OBTENIDO \|' "$REGISTRO")
    if [ "$filas" -ne "$n_resp" ]; then
        fail "$REGISTRO tiene $filas filas, deberian ser $n_resp (una por participante de respuestas.csv)"
    elif [ "$pendientes" -gt 0 ]; then
        fail "$pendientes de $filas participantes siguen en PENDIENTE en $REGISTRO"
    elif [ "$obtenidos" -eq "$filas" ]; then
        pass "las $filas constancias de consentimiento estan marcadas OBTENIDO en $REGISTRO"
    else
        fail "$REGISTRO tiene filas en un estado distinto de OBTENIDO/PENDIENTE (revisar a mano)"
    fi
fi

# ---------------------------------------------------------------------
section "P14 -- correccion por comparaciones multiples, reproducible"
# Busca por CONTENIDO, no por nombre de archivo: el script vigente se
# llama perf-analysis.py, no *bonferroni*/*holm* (asi se nos paso la
# primera vez -- ver VERIFICACION.md).
stats_script=$(grep -rl "holm_bonferroni\|holm-bonferroni\|Holm-Bonferroni" scripts/*.py 2>/dev/null)
if [ -n "$stats_script" ]; then
    if grep -q "p-valor\|Holm (α=0,05)\||\s*p\s*|" docs/mediciones/perf/REPORT.md 2>/dev/null; then
        pass "script de correccion encontrado ($stats_script) y su salida ya esta en docs/mediciones/perf/REPORT.md"
    else
        fail "$stats_script existe pero docs/mediciones/perf/REPORT.md no trae la tabla de p-valores corregidos"
    fi
else
    fail "no existe ningun script/cuaderno versionado que calcule los p-valores corregidos"
fi

# (Corrección 2026-09-17, evaluación integral: los dos chequeos de arriba
# solo confirman que la tabla EXISTE, no que sus numeros sean los que
# produce el script sobre los datos crudos -- alguien podria editar a
# mano un p-valor en REPORT.md y esto seguiria pasando. Se regenera
# REPORT.md desde los *.samples.json reales y se compara contra la
# version versionada, ignorando las 3 lineas de metadato que cambian
# entre corridas por diseño -- Fecha, Commit, Herramienta -- y
# restaurando el archivo al terminar, se termine bien o mal.)
REPORT_PERF=docs/mediciones/perf/REPORT.md
if [ -f "$REPORT_PERF" ]; then
    cp "$REPORT_PERF" "$REPORT_PERF.bak-verify"
    if PYTHONIOENCODING=utf-8 python3 "$stats_script" >/dev/null 2>&1; then
        diff_real=$(diff <(grep -vE '^- (Fecha|Commit|Herramienta):' "$REPORT_PERF.bak-verify") \
                         <(grep -vE '^- (Fecha|Commit|Herramienta):' "$REPORT_PERF") || true)
        if [ -z "$diff_real" ]; then
            pass "REPORT.md regenerado desde los datos crudos es idéntico al versionado (fuera de Fecha/Commit/Herramienta)"
        else
            fail "REPORT.md versionado difiere del que produce $stats_script sobre los mismos datos crudos: $(echo "$diff_real" | head -6 | tr '\n' ' ')"
        fi
    else
        fail "$stats_script no pudo regenerar REPORT.md (revisar PYTHONIOENCODING=utf-8 y las dependencias)"
    fi
    mv -f "$REPORT_PERF.bak-verify" "$REPORT_PERF"
fi

# ---------------------------------------------------------------------
section "Regresion -- seccion 1 (lo que la guia ya da por resuelto)"
if ls docs/informe*.pdf docs/informe/*.pdf >/dev/null 2>&1; then pass "el informe en PDF existe"; else fail "no se encuentra el informe en PDF (correr 'make docs')"; fi
if grep -q "onrender.com" README.md; then pass "README declara las URL publicas del despliegue"; else fail "README no declara URL publicas"; fi
if grep -qE 'Access-Control-Allow-Origin.*\*|setAllowedOrigins\(.*\*' backend/src/main/java -r 2>/dev/null; then
    fail "se encontro un comodin en la configuracion de CORS"
else
    pass "CORS sin comodines (grep negativo)"
fi

# ---------------------------------------------------------------------
echo
echo "===================================================="
echo "Resumen: $PASS_COUNT pasan, $FAIL_COUNT fallan, $MANUAL_COUNT pendientes de revision manual"
echo "===================================================="
exit $FAIL

# Solicitud de confirmación al docente evaluador — SGED (2026-09-22)

Ante el reporte de evaluación del 22 de septiembre de 2026, el equipo SGED
solicita al docente evaluador la confirmación de los tres pendientes que ese
reporte marca como dependientes de su palabra (P7, P12 y P13). Si los
confirma, el proyecto queda en 10,00 según la lectura favorable del propio
reporte.

Repositorio: `https://github.com/gleiston-guerrero/SGED_APPWEB`
Commit evaluado: `849222f` (etiqueta anotada `v1.1.0` sobre el commit).

---

## P7 — SRS firmado y MoSCoW

**Lo que pedimos confirmar.** Que el Ing. Gleiston Cicerón Guerrero Ulloa,
Ph.D. confirmó por escrito al equipo, el 2026-09-18, que la firma del acta
de aprobación del SRS v1.8 sigue vigente y es suficiente para la versión
vigente del SRS (v1.11), sin exigir una firma nueva ni volver a someter el
documento.

**Dónde está la evidencia en el repositorio.**

- Nota de la confirmación: `docs/requisitos/SRS.md`, sección 7, bloque
  «Confirmación del docente-director (2026-09-18)» (línea ~2101):
  «Ante la consulta del equipo sobre si el examen suspenso requería una
  nueva firma para la v1.11, el Ing. Gleiston Cicerón Guerrero Ulloa, Ph.D.
  confirmó directamente al equipo que la firma ya emitida sobre la v1.8
  (`ACTA-APROBACION-SRS-v1.8.pdf`, 2026-09-12) sigue vigente y es
  suficiente».
- Acta firmada electrónicamente el 2026-09-12:
  `docs/requisitos/ACTA-APROBACION-SRS-v1.8.pdf`
  (SHA-256: `f70a803b0b473c83f8d21d3aa43eb4b9ca8f2ca85ac6754c854017f8cf48e104`).
- SRS vigente publicado con su PDF: `docs/requisitos/SRS-v1.1.0.pdf`
  (SHA-256: `938f0ce2d351a9fc9c8a889493f378a337fea79f9d132f1ae90c34290fa41a3b`),
  regenerado desde `SRS.md` (80 requisitos con prioridad MoSCoW).
- Confirmación registrada además en git: commit `d646f518`, 2026-09-18
  «fix(examen-suspenso): cierra P7 — docente-director confirma que la
  firma de v1.8 sigue vigente».

**Comandos de verificación.**

```bash
git rev-parse v1.1.0^{commit}          # 849222f (commit evaluado)
sha256sum docs/requisitos/ACTA-APROBACION-SRS-v1.8.pdf
sha256sum docs/requisitos/SRS-v1.1.0.pdf
git log -1 d646f518 --format="%h %ai %s"
```

Los 80 requisitos del SRS llevan su prioridad MoSCoW; el acta de la v1.8
lleva la firma del docente.

---

## P12 — Umbral de cobertura

**Lo que pedimos confirmar.** Que `docs/informe-entrega-3.pdf`, un hito
anterior ya calificado (Informe de la Tercera Entrega, 27 páginas), queda
**fuera** del entregable del examen suspenso y, por tanto, no debe tomarse
como una segunda cifra de umbral. El entregable del examen suspenso declara
una sola cifra: 70 %.

**Dónde está la evidencia en el repositorio.**

- Umbral único declarado en el pom: `backend/pom.xml`, comentario (líneas
  ~191-197) y límites JaCoCo (líneas ~208-219): mínimo **0,70** en
  `LINE` y en `BRANCH`, sin excepciones de paquete.
- Informe de la entrega: `docs/informe/main.pdf` (74 páginas) y
  `docs/informe-final.pdf`.
- Versión: `CITATION.cff` → `version: 1.1.0`.
- El `docs/informe-entrega-3.pdf` fue el informe de la tercera entrega
  (2026-07-30), cuando el umbral exigido de esa etapa era distinto del
  vigente; ese hito ya fue calificado en su momento y su PDF se mantiene
  en el repositorio solo como archivo.

**Postura del equipo:** los hechos quedan expuestos tal cual; la decisión
de si ese PDF histórico forma parte del entregable del examen suspenso es
del docente.

---

## P13 — Consentimientos

**Lo que pedimos confirmar.** Que los 15 consentimientos firmados están en
la carpeta de Google Drive restringido y que sus huellas SHA-256 coinciden
con las declaradas en el registro del repositorio.

**Dónde está la evidencia en el repositorio.**

- Documentación y enlace: `docs/etica/consentimiento/registro.md`
  (sección «Acceso del docente a los originales (2026-09-19)», carpeta
  `SGED_consentimientos_originales/SUS-2026-09/`).
- Modelo del consentimiento: `docs/etica/consentimiento/plantilla.md`
  (§4 prevé compartir los datos con el docente evaluador y archivarlos en
  acceso restringido).
- Tabla de integridad: 15 filas con `ARCHIVO / SHA-256` en
  `registro.md` (sección «Verificación de integridad (SHA-256)»), calculada
  el 2026-09-17.
- Verificación de acceso (2026-09-20): Ricardo Vélez López, investigador
  responsable, confirmó desde su cuenta que el enlace abre la carpeta y que
  los 15 `.docx` se visualizan.
- `scripts/verify.sh` (P13) comprueba el modelo, el registro y el resumen
  criptográfico.

**Comando de verificación** (con el original en mano, tras descargarlo de
la carpeta):

```bash
sha256sum Consentimiento_01-SUS-SGED.docx   # debe imprimir d54ea76f...
```

Cada fila esperada figura en `docs/etica/consentimiento/registro.md`, desde
`Consentimiento_01` (`d54ea76f...`) hasta `Consentimiento_15`
(`e51b04d5...`).

---

## Nota de transparencia (fuera de criterio, no resta puntos)

El reporte §1.5 anota cuatro alteraciones que el verificador «deja pasar»
sin que correspondan al criterio de ningún pendiente: dos redacciones del
umbral excluidas por la lista blanca, subir un rendimiento de Lighthouse en
la tabla local del informe y alterar un resumen del registro de
consentimientos. El equipo las conoce y no las ha invocado como cierres;
quedan declaradas para que el docente decida si requieren endurecimiento
adicional.

---

*SGED — Sistema de Gestión para la Escuela Deportiva ProFútbol.*
*Aplicaciones Web — Quinto nivel — PPA 2026-2027.*
*Equipo: Arcalle Grefa Darwin Orlando · Vélez López Ricardo Elías · Pallo
Pinto Alejandro Daniel.*
# Defensa individual — Ricardo Elías Vélez López

**Examen suspenso del PFC — SGED (PPA 2026-2027)**
**Fecha:** 2026-09-21
**Evaluador:** Dr. Gleiston Cicerón Guerrero Ulloa, Ph.D.

Documento de defensa de **Ricardo Elías Vélez López** (rvelezl3@uteq.edu.ec).
La guía exige que cada integrante explique, sin ayuda, el código y la
evidencia de los puntos que declara suyos; este documento responde por los
puntos que declaro en [`CONTRIBUCIONES.md`](../../CONTRIBUCIONES.md) y por
las preguntas que la evaluación del 20-sep dejó señaladas. Cada apartado
sigue el mismo esquema: **qué hice, por qué así, qué alternativas descarté
y cómo se comprueba** (código/commits).

---

## P7 — Firma vigente del SRS (peso 0,8) · `9810639e`

**Qué hice.** Endurecí el verificador de P7 para que deje de pasar en
falso. Antes, el chequeo solo confirmaba que el acta de aprobación del SRS
existiera; podía estar desactualizada respecto a la versión vigente del
documento y `make verify` seguía saliendo verde. Ahora **P7 puede fallar**:
si falta la confirmación del docente-director, la verificación sale con
código 1.

**Por qué así.** Un chequeo que pasa siempre no verifica nada. El fallo
real que descubrimos era de este tipo: falta que la firma emitida cubra la
versión vigente del SRS. La vía correcta no era maquillar el script sino
preguntar al docente: el 2026-09-18 el Ing. Guerrero confirmó directamente
al equipo que la firma de la v1.8 (`ACTA-APROBACION-SRS-v1.8.pdf`,
2026-09-12) sigue vigente y es suficiente para la v1.11, con la
nomenclatura de RF-11c y los enums ya documentados en
`docs/requisitos/SRS.md`.

**Qué descarté.** Regenerar el acta y someterla de nuevo a firma: el propio
docente aclaró que una sincronización de nomenclatura sobre requisitos
`✅ Implementado` no amerita reabrir el ciclo de firma. La alternativa de
simplemente ampliar el SRS en silencio habría vuelto a dejar la evidencia
sin cubrir toda la versión — no la usamos.

**Cómo se comprueba.** En `scripts/verify.sh`, el bloque de P7 ancla la
frase `Confirmación del docente-director (2026-09-18)` en `SRS.md` y el
documento `ACTA-APROBACION-SRS-v1.8.pdf`. Probé la mutación (quito esa
frase de `SRS.md`): `make verify` **FALLA** con código 1. Restaurada,
vuelve a pasar. Está documentado en [`VERIFICACION.md`](../../VERIFICACION.md)
(sección P7).

**Además (2026-09-20).** Verifiqué personalmente, desde mi cuenta, que el
enlace de Google Drive de los consentimientos abre con los 15 `.docx`
visibles y lo dejé anotado en `docs/etica/consentimiento/registro.md`.

---

## P1 — Respuestas del SUS (peso 1,3) · `d973292`

**Qué hice.** Añadí al informe del SUS (`docs/mediciones/sus/REPORT.md`) la
sección de **amenazas a la validez y limitaciones de muestra**, que es
justo lo que el examen pedía: no basta la cifra, hay que explicar qué
condiciones la acotan. Documenté que la muestra es de **15 participantes
externos**, los efectos de un muestreo por conveniencia, el tamaño del
efecto y por qué el IC 95 % (58,87–79,79) se calculó con t de Student con
gl=14 y t=2,145.

**Por qué así.** La media SUS 69,33 es solo una parte de la respuesta; la
validez de esa media depende de que se declare su límite. La t de Student
es la distribución correcta para el IC de la media con muestra pequeña y
varianza desconocida (no la normal: con n=15 la normal subestima el error).

**Qué descarté.** Usar la normal estándar para el IC, o presentar la media
sin intervalo — las dos habrían sido incorrectas o incompletas.

**Cómo se comprueba.** `grep -i "brooke" docs/mediciones/sus/REPORT.md`
muestra el instrumento (Brooke, 1996); `grep -i "t de Student"` muestra
gl=14, t=2,145; el bloque «Amenazas a la validez» está versionado en el
commit `d973292`. El verificador de P1 (`scripts/verify.sh`) regenera
`REPORT.md` desde `respuestas.csv` con `sus-analysis.py` y lo compara con
el versionado: la cifra es reproducible de extremo a extremo.

---

## P2 — Corridas R2RS (`r2rs`, peso 0,9) · `0ecf27a` — junto con el equipo

**Qué hice.** Generé y versioné las corridas de Lighthouse para el
despliegue público `r2rs` (3 rondas desktop + 3 rondas mobile sobre el
sitio público desplegado), sus `report.json` crudos y el resumen en
`docs/mediciones/lighthouse/REPORT.md`. P2 se apoya en esas evidencias.

**Por qué así.** Las métricas de rendimiento de un PWA solo valen si se
miden contra el despliegue real (no contra localhost) y con datos crudos
versionados, para que cualquiera pueda recomputar el resumen.

**Qué descarté.** Reportar solo el resumen sin los `report.json`; y medir
sobre la máquina de desarrollo — habría sido no reproducible y no
representativo.

**Cómo se comprueba.** `docs/mediciones/lighthouse/REPORT.md` resume las 6
corridas; los `*.report.json` están under
`docs/mediciones/lighthouse/`. `CONTRIBUCIONES.md` dispara este punto
conjuntamente (las corridas las preparé junto con Darwin Arcalle).

---

## P12 — Una sola cifra de umbral de cobertura (peso 0,5) · `5f99078`

**Qué hice.** Corregí la redacción del umbral de cobertura para que el
entregable diga **una sola cifra: 70 %**, y ataqué el hecho falso por el
que la evaluación v2 (17-sep) nos señaló: el valor heredado era un resto
de configuración del pasado. Nunca fue el umbral activo; una afirmación
rápida lo elevó a regla.

**Qué descarté/detecté.** La evaluación probó 4 redacciones del hecho falso
sobre la palabra `umbral` y 3 sobrevivían al patrón existente. Por eso la
corrección no es solo de texto: `scripts/verify.sh` ahora reconoce la forma
entera en todos sus formatos y rechaza cualquier afirmación viva que mezcle
un ancla de umbral con una cifra distinta de la real, 70 %. Excluí por
diseño el artefacto congelado donde la cifra histórica queda documentada
como tal (es evidente que es histórica y no vigente).

**Cómo se comprueba.** En `scripts/verify.sh`, el bloque P12 ejecuta
`NUM60='(60|0[.,]6(0)?|[Ss]esenta)'` con `git grep` sobre todo el repo
versionado (excluye solo `OBSERVACIONES.md`, el spec congelado y locks):
mutación «sesenta por ciento en letras» → **FALLA** (comprobado el
2026-09-21). La sección P12 de [`VERIFICACION.md`](../../VERIFICACION.md)
narra el antecedente completo.

---

## P13 — 15 consentimientos informados (peso 0,5)

**Qué hice y cómo se comprueba.** Las 15 constancias de consentimiento del
SUS están marcadas `OBTENIDO` en
`docs/etica/consentimiento/registro.md`, con el hash **SHA-256** de cada
original `.docx` (calculado 2026-09-17), sin exponer datos personales. El
verificador P13 de `verify.sh` exige que las 15 estén marcadas `OBTENIDO`
en el registro. En la defensa puedo presentar los originales: cualquiera
con el archivo en mano verifica `sha256sum` contra la tabla. El enlace de
la carpeta restringida está en el registro; el docente puede solicitar
acceso a Darwin Arcalle.

**Limitación declarada con honestidad:** ni la evaluación integral ni la
del examen suspenso pudieron abrir la carpeta por diseño (datos
personales); por eso la evidencia pública es el hash + el marcado, y la
verificación presencial queda para la defensa. Esto está escrito tal cual
en el registro, no oculto.

---

## Preguntas que la evaluación del 20-sep anticipó (respuestas cortas)

1. **«¿Por qué el informe trae la cifra sesenta por ciento si la
   cobertura exigida es 70 %?»**
   Es una redacción histórica de un artefacto congelado. El umbral activo
   es y fue **70 %** (`pom.xml`: `<minimum>0.70</minimum>`); la cifra
   menor fue un valor de configuración previo que una afirmación elevó a
   regla por error. La afirmación errónea se corrigió y `verify.sh` hoy
   detecta cualquier afirmación viva que mezcle una cifra con el ancla de
   umbral.

2. **«¿Dónde están los 15 consentimientos?»** Los 15 originales firmados
   están en la carpeta restringida de Google Drive del registro; sus
   huellas SHA-256 están publicadas; el marcado `OBTENIDO` para los 15
   está versionado y verificado. El acceso presencial se resuelve en la
   defensa o pidiendo acceso al docente.

3. **«¿La firma del SRS cubre la versión actual?»** Sí: la firma v1.8
   (acta del 2026-09-12) cubre también la v1.11 por confirmación expresa
   del docente-director (2026-09-18), con la nomenclatura de RF-11c y los
   4 enums documentados en el SRS. `make verify` falla si falta esa
   confirmación.

---

**Resumen de trazabilidad (commits míos en el historial):**

| Punto | Commit | Qué lo sostiene |
| --- | --- | --- |
| P7 | `9810639e` | P7 puede fallar; confirmación docente anclada; Drive verificado |
| P1 | `d973292` | amenazas a la validez en `REPORT.md` |
| P2 | `0ecf27a` | corridas R2RS versionadas |
| P12 | `5f99078` | una sola cifra de umbral (70 %); `NUM60` con `[Ss]esenta` |
| P13 | `5f99078` y posteriores | 15 `OBTENIDO` + hashes en el registro |

*Firmado digitalmente en la defensa por Ricardo Elías Vélez López.*
# Declaración de aportes — examen suspenso (EV-4)

Guía del examen suspenso, UTEQ — Aplicaciones Web, PPA 2026-2027. Por cada
uno de los 14 pendientes de la guía: quién lo cerró, con qué archivos y con
qué commits, contrastado contra `git log` (no autodeclarado). Es la base de
la calificación individual (sección 4 de la guía).

Metodología: para cada punto identifico (a) el trabajo de fondo ya
existente en el repositorio y quién lo escribió, y (b) el cierre específico
que resuelve lo que la guía marcó como pendiente, con sus commits. Cuando
ambos coinciden en la misma persona lo digo una sola vez. Los correos son
los institucionales de cada integrante, tomados de
[`CONTRIBUTORS.md`](CONTRIBUTORS.md).

| Integrante | Correo institucional |
|---|---|
| Arcalle Grefa Darwin Orlando | darcalleg@uteq.edu.ec |
| Pallo Pinto Alejandro Daniel | dpallop@uteq.edu.ec |
| Velez Lopez Ricardo Elias | rvelezl3@uteq.edu.ec |

---

## P1 — Respuestas del SUS (peso 1,3)

**Titular del cierre:** Arcalle Grefa Darwin Orlando, con la contribución
específica de Velez Lopez Ricardo Elias descrita abajo.

- Los 15 registros reales, el recálculo Brooke y el intervalo de confianza
  con t de Student ya eran trabajo de fondo de **Pallo Pinto Alejandro
  Daniel** (`docs/mediciones/sus/respuestas.csv`, `REPORT.md`,
  `INTERPRETACION.md`; commits `40f4d39`, `de93a8f`, `0a19cb6`, entre
  otros) y de **Velez Lopez Ricardo Elias** (amenazas a la validez,
  commit `d973292`).
- Lo que bloqueaba el punto (consentimiento de cada participante) se
  cerró junto con P13 — ver esa sección. El cierre en sí (destrabar P1
  una vez obtenido el consentimiento) es de **Arcalle Grefa Darwin
  Orlando**, `VERIFICACION.md` (commit `7f6f424`).

## P2 — Lighthouse (peso 0,9)

**Titular del cierre:** Velez Lopez Ricardo Elias y Arcalle Grefa Darwin
Orlando.

Las 3 corridas por perfil (móvil/escritorio) versionadas en
`docs/mediciones/lighthouse/` son trabajo de fondo de **Pallo Pinto
Alejandro Daniel**, previo a la guía (commit `9f75e71`, 28-jul). La guía
encontró que no había informe de Lighthouse contra el despliegue público,
y ese es el cierre que corrigió: **Velez Lopez Ricardo Elias**, las seis
corridas contra el despliegue público real `r2rs` y la exigencia de URL
pública en el verificador (commit `0ecf27a`); **Arcalle Grefa Darwin
Orlando**, las corridas de panel e inventario y la corrección de dos
causas reales de CLS que las corridas exponían (commit `efa0ca0`).
(Corrección 2026-09-18: la versión anterior de este expediente declaraba
"no requirió cierre adicional en esta ronda", lo que contradecía el
hallazgo de la guía y el trabajo real posterior.)

## P3 — DOI retirado (peso 0,5)

**Titular del cierre:** Arcalle Grefa Darwin Orlando.

`scripts/check-doi.sh` (comprueba que todos los DOI de Zenodo citados y
los de la bibliografía resuelvan como se espera) se agregó en el commit
`c2c36fa`. Desde el 19-sep (`f2c0f11`) exige 200 en todos los DOI de
Zenodo citados y falla si vuelve a citarse el depósito retirado (410),
que se quitó de las citas: la guía pide "todos los DOI declarados
resolviendo a 200". La gestión previa de los DOI de Zenodo across releases
es compartida entre los tres integrantes a lo largo del proyecto (ver
`CITATION.cff` y su historial); el cierre específico de este punto —la
verificación reproducible— es de Arcalle Grefa.

## P4 — Javadoc (peso 1,5)

**Titular:** Pallo Pinto Alejandro Daniel, con el cierre específico de
Arcalle Grefa Darwin Orlando descrito abajo.

- Grueso de la documentación Javadoc añadida por **Pallo Pinto Alejandro
  Daniel** en los commits `3441c02` (98 DTO record), `fa8573e` (22
  entidades JPA) y `335ac57` (resto de entidades) — los tres a nombre de
  `Alejandro-hub19 <dpallop@uteq.edu.ec>`, verificado contra `git log`.
- El cierre específico de **Arcalle Grefa Darwin Orlando**: `e666d41`
  (repositorios y corrección de `@param` obsoletos) y, en esta ronda
  final, corregido un defecto real de `scripts/javadoc-coverage.py` (no
  seguía anotaciones partidas en varias líneas ni saltaba comentarios
  `//` sueltos, lo que hacía ver 90,03% donde en realidad había 100%),
  eliminada una duplicación accidental de Javadoc en
  `ConsentRepository.java`, y documentado el constructor compacto de
  `AnonymousPlayerProfile` (el único método genuinamente sin Javadoc de
  los 61 que reportaba la lista). Commit `39ca9fa`.
- Resultado: 506/506 métodos y constructores públicos con Javadoc
  (100%), 499/506 completos con `@param` y `@return` (98,6%),
  `mvn javadoc:javadoc` sin error. (Corrección 2026-09-16: la cifra
  612/612 de la versión anterior del expediente contaba 102
  declaraciones `record` como métodos; el conteo correcto es el del
  párrafo anterior.)

## P5 — Validador de trazabilidad (peso 0,6)

**Titular:** Arcalle Grefa Darwin Orlando, sobre la base de Pallo Pinto
Alejandro Daniel.

El defecto original ("el validador nunca podía fallar") lo corrigió
Pallo Pinto (commit `3297ec0`); Arcalle Grefa forzó UTF-8 en su
salida (`6fd0581`) y, en el expediente EV-1/EV-2 (`c2c36fa`), hizo que
`make verify` invoque el script en cada corrida — que era el defecto real
que seguía abierto (nada lo llamaba automáticamente).

## P6 — Figuras en inglés (peso 0,7)

**Titular:** Arcalle Grefa Darwin Orlando.

Traducción de las fuentes (Mermaid, SVG, DSL de C4) en los commits
`215a4ec` y `f8aeb48`. Revisión visual final de los 11 PNG rasterizados
(no cubiertos por grep) — 6 en `docs/arquitectura/` (incluidos los 3
divididos por dominio del C4 nivel 3) y 5 en `docs/diagramas/`
(incluidos los 4 del MER dividido por esquema) — confirmando que están
100% en inglés. Cierre inicial en `VERIFICACION.md` (commit `7f6f424`);
conteo corregido de 4 a 11 el 2026-09-17/18 (evaluaciones v2 y del
18-sep), tras dividir el C4 nivel 3 (P6, commit `d5e8aa4`) y el MER
(commit `51ba4dc`) por módulo.

## P7 — SRS firmado, con MoSCoW (peso 0,8)

**Titular:** Arcalle Grefa Darwin Orlando.

El campo MoSCoW en `docs/requisitos/SRS.md` es trabajo de fondo
compartido del equipo a lo largo de las revisiones del SRS. El registro
de la firma del docente-director en el acta de aprobación es de Arcalle
Grefa (commit `cead25d`). El pipeline reproducible que genera
`docs/requisitos/SRS-v1.1.0.pdf` (`scripts/build-srs-pdf.sh`, `make srs`)
es de Arcalle Grefa, commit `fca011a`.

## P8 — Etiqueta única v1.1.0 (peso 0,6)

**Titular:** Arcalle Grefa Darwin Orlando.

Etiqueta movida y referencias actualizadas (portada, CITATION.cff,
README, SRS) en el commit `ebd4b69`, con la corrección posterior del
chequeo de `CITATION.cff` (`cc6b905`) y de la dereferenciación del commit
real de la etiqueta anotada (`74af4dd`).

## P9 — Nombres de tipos en inglés (peso 0,7)

**Titular:** Arcalle Grefa Darwin Orlando.

Renombrado de identificadores a inglés en los commits `f6ff161`
(backend), `4536466` (frontend, alineado a los DTO renombrados) y
`011fc15` (valores de 4 enums de dominio). Revisión manual final de los
277 nombres de tipo del backend uno por uno en esta ronda, confirmando
0% en español — `VERIFICACION.md` (commit `7f6f424`).

## P10 — Roles CRediT con conteo real (peso 0,5)

**Titular:** Arcalle Grefa Darwin Orlando, sobre la base de Pallo Pinto
Alejandro Daniel.

La declaración original de roles CRediT es de Pallo Pinto (commit
`ebb5906`). El defecto que señalaba la guía (el número junto a cada
persona era su total de commits, repetido en cada fila) lo corrigió
Arcalle Grefa con `scripts/credit-counts.py` (conteo real por rol y
rutas de archivo), commit `634537b`.

## P11 — Clave de ejemplo (peso 0,4)

**Titular:** Arcalle Grefa Darwin Orlando, sobre la base de Pallo Pinto
Alejandro Daniel.

`.env.example` es trabajo de fondo de Pallo Pinto. El reemplazo del valor
con aspecto real por el marcador `CAMBIAR_EN_PRODUCCION_...` es de
Arcalle Grefa, commit `634537b`.

## P12 — Umbral de cobertura unificado (peso 0,5)

**Titular del cierre:** Arcalle Grefa Darwin Orlando y Velez Lopez Ricardo
Elias.

La corrección original de esta misma inconsistencia (RNF-09 citaba el
umbral equivocado) es de **Pallo Pinto Alejandro Daniel**, commit
`76e4e48` (2-sep), trabajo de fondo previo a la guía. El cierre posterior
a la guía, con el barrido y la detección por mutación que exige el
criterio, es de: **Arcalle Grefa Darwin Orlando**, corrección de la
afirmación falsa sobre el 60% en `main.tex`/`SRS.md` (commit `04cf112`) y
ampliación del patrón de detección a redacciones evasivas — "60 por
ciento", "0,6", "60~\%" (commit `af23fb9`); **Velez Lopez Ricardo Elias**,
extensión del barrido a todo el repositorio y al formato LaTeX, con
corrección de la cita `0.60` en `iso25010` (commit `5f99078`).
(Corrección 2026-09-18: la versión anterior de este expediente atribuía
el cierre entero a Pallo Pinto por el commit de 2-sep, ignorando el
trabajo posterior a la guía.)

## P13 — Consentimientos informados del SUS (peso 0,5)

**Titulares:** Velez Lopez Ricardo Elias (obtención real del
consentimiento) y Arcalle Grefa Darwin Orlando (mecanismo de registro).

El mecanismo para comprobar el consentimiento sin exponer datos
personales en el repositorio público (`docs/etica/consentimiento/
registro.md`, endurecimiento de `scripts/verify.sh`) es de Arcalle Grefa,
commit `ee0e699`. La plantilla de consentimiento sobre la que se firmó
(`plantilla.md`) es trabajo de fondo compartido (commits `fb08831` de
Velez Lopez y `9fc1801`/`eca162c` de Pallo Pinto y Arcalle Grefa).

**El cierre real de este punto es trabajo de campo de Velez Lopez Ricardo
Elias**: contactó a los 15 participantes reales de la encuesta SUS y les
hizo firmar el consentimiento el 2026-09-14, como formalización
retroactiva del consentimiento ya otorgado verbalmente en las sesiones
del 2026-07-30 y 2026-08-18, firmando él mismo como investigador
responsable en las 15 constancias. Arcalle Grefa verificó cada constancia
individualmente y actualizó el registro (commit `7f6f424`); los 15
originales firmados (con nombre y firma reales, dato personal) no se
suben al repositorio, según el propio diseño de `plantilla.md`.

## P14 — Estadística con trazabilidad (peso 0,5)

**Titular:** Arcalle Grefa Darwin Orlando, sobre la base de Pallo Pinto
Alejandro Daniel.

`scripts/perf-analysis.py`, incluida la función `holm_bonferroni`, es
trabajo de fondo de Pallo Pinto (commits `734a79f`, `7ce1474` y
siguientes). El punto que señalaba la guía (encontrar esa trazabilidad
sin depender de buscar por nombre de archivo) se cerró documentándolo
explícitamente en `VERIFICACION.md`, commit `634537b`, de Arcalle Grefa.

---

## Trabajo adicional del 17/18-sep (posterior al primer cierre de este expediente)

**Defecto señalado por la evaluación del 18-sep:** este expediente no se
había tocado desde el 16-sep y no declaraba nada del trabajo real hecho
después — en particular, perjudicaba la atribución de Vélez López,
autor del commit que devolvió `make verify` a código 0 la noche del
17-sep. Se corrige aquí con la lista completa de commits por persona,
contrastada contra `git log 2c2c7cf..HEAD`.

**Vélez López Ricardo Elías** (correo institucional en los 5 commits):

| Commit | Qué hace |
|---|---|
| `5f99078` | Corrige el defecto real de conteo de Javadoc (P4), y ajusta P5, P10, P11, P12, P14 tras la revisión preliminar del 16-sep |
| `a6ab791` | Quita un literal `0.60` de `VERIFICACION.md` que rompía el propio chequeo de P12 |
| `0ecf27a` | P2 contra el despliegue real (`r2rs`), expediente de P6/P8, PDF regenerado, `CITATION.cff` |
| `43c79cb` | Corrige `CHANGELOG.md` (retiro falso de `informe-entrega-3.pdf`), ajustes de `VERIFICACION.md`, elimina el `informe-final.pdf` duplicado huérfano de la raíz |
| `e19929a` | **Mueve el chequeo del acta de P7 a "revisión manual"** — el cambio puntual que devolvió `bash scripts/verify.sh` a código de salida 0 la noche del 17-sep, sin el cual la nota quedaba topada en 40% |

**Arcalle Grefa Darwin Orlando** (correo personal, declarado y justificado más abajo):
autor del resto de los commits de este período — correcciones de P2
(CLS real del dashboard), la falsa afirmación del 60% (Piso 3), P5
(prueba sobre fila real de la matriz), P6 (C4 nivel 3 dividido por
dominio), P7 (confirmación del docente-director sobre la firma de la
v1.8), P8 (retiro de `v1.0.1`–`v1.0.3`), P10 (resincronización de las
tablas de roles), P11 (`CONTRASENA_ADMIN` real), P12 (endurecimiento
del patrón de detección) y P13 (hash SHA-256 de los 15 consentimientos)
— y del endurecimiento general de `scripts/verify.sh` contra las
mutaciones de las evaluaciones del 17 y 18-sep.

**19-sep (Arcalle Grefa Darwin Orlando, correo personal):**

| Commit | Qué hace |
|---|---|
| `f2c0f11` | P3: retira de las citas el DOI de Zenodo retirado (410) y reescribe `scripts/check-doi.sh` para exigir 200 y vigilar que no vuelva; P13: enlaza en `registro.md` la carpeta de Drive de acceso restringido con las 15 constancias |
| el commit posterior a `f2c0f11` | Corrige la frase caducada de P11 (`.env.example` sí contenía el literal antiguo), los bloques P2/P8/P10 desactualizados de `VERIFICACION.md`, `scripts/credit-counts.py` con revisión fija, `scripts/javadoc-coverage.py` que ahora exige texto y `@param`/`@return`, y este expediente |
| 20-sep, `verify.sh` y `javadoc-coverage.py` | Cinco hallazgos de la evaluación del 19-sep: P8 exige que la etiqueta apunte a `HEAD`; un `{@inheritDoc}` solo ya no cuenta como Javadoc; el barrido de P12 reconoce la cifra escrita en letras; se corrige la tabla de EV-2 (P4 ya está endurecido); la salida de P1 se pega completa. Commit hecho con el correo institucional de Arcalle Grefa (`darcalleg@uteq.edu.ec`) |

| 20-sep (2), `verify.sh` y `javadoc-coverage.py` | Verificación de contenido: P4 exige descripción en `@param`/`@return` y `@throws` en los 46 métodos que lanzan excepción (más el constructor compacto de `AnonymousPlayerProfile`); P1 regenera el `REPORT.md` del SUS y lo compara; P10 recalcula las cifras de CRediT sobre un commit fijo. Commit con el correo institucional de Arcalle Grefa |

**20-sep (3), Vélez López Ricardo Elías** (correo institucional en el commit):

| Commit | Qué hace |
|---|---|
| `9810639e` | **P7 realmente puede fallar**: endurece el verificador para que una ausencia de la confirmación del docente-director en `SRS.md` dé código 1 (antes pasaba en falso). Verifica además, desde su cuenta, que el enlace de Drive de P13 abre con los 15 `.docx` visibles y lo deja anotado en `registro.md` |

**21-sep, Arcalle Grefa Darwin Orlando** (correo institucional):

| Commit | Qué hace |
|---|---|
| `20135de7` | Cierra la **lectura estricta de P4** con el mismo método del evaluador: versiona `scripts/javadoc-ast-coverage.java` — un analizador con el **AST real de javac** que exige texto propio, `@param`/`@return` con descripción y `@throws` por cada excepción declarada y por cada `throw new` (503/503 = 100 %, umbral 100). `verify.sh` lo invoca y falla si la completitud baja del 100 %. Asienta además en `VERIFICACION.md` que **todas las mutaciones del informe 20-sep fallan** sobre el HEAD (etiqueta a 2 commits, Javadoc a `{@inheritDoc}`, menos `@throws`, «sesenta por ciento», media SUS, cifra CRediT, p-valor, segunda etiqueta, frase de P7, `JWT_SECRET`) |

**21-sep (2), retirado:** los commits `634fe7a` y `4b73b7d` (de Arcalle
Grefa) subieron `docs/defensa/DEFENSA.md`, un guion de preparación escrito
en primera persona como si fuera la defensa individual de Vélez López. La
guía pide una defensa **oral**, no un documento, y el historial no
respalda que ese texto sea de Vélez López: lo escribió y lo modificó
Arcalle Grefa, y el segundo commit reescribió frases para que el barrido
de P12 no las detectara. Era material interno del equipo y no correspondía
al repositorio; se retiró en el commit que acompaña este cambio (sigue en
el historial de git, no se oculta). Cada integrante prepara su defensa por
su cuenta y la da de viva voz.

**21-sep (3), Arcalle Grefa Darwin Orlando** (correo institucional): cierra
los hallazgos de la evaluación final v2 que se podían resolver en el
repositorio: retira `docs/defensa/DEFENSA.md`; quita la palabra «vigente»
de la lista blanca del barrido de P12; exige etiqueta anotada (P8); cruza
`respuestas.csv` con `registro.md` y con fechas reales (P1); compara con los
datos crudos lo que publican el informe (media y IC del SUS, tabla pública
de Lighthouse) y `REPORT.md` de Lighthouse (P1, P2); alinea con
`credit-counts.py f2c0f11` la tabla CRediT del informe, que omitía a Pallo
Pinto en tres roles (P10); corrige en el informe las cifras de Lighthouse
(mejor rendimiento de escritorio y 96 en buenas prácticas, no 100); añade
descripción principal a 145 bloques de Javadoc y la exige en los dos
medidores (P4); y sustituye en `VERIFICACION.md` la afirmación falsa de que
«no quedaba ninguna mutación viva» por la tabla real, con la que sobrevive.

---

## Entregables EV-1/EV-2/EV-3 (sin peso propio, pero condicionan los 14 puntos)

`VERIFICACION.md`, `scripts/verify.sh`/`make verify` y la etiqueta
`v1.1.0` son de **Arcalle Grefa Darwin Orlando** (commits `c2c36fa` y
siguientes hasta el cierre de este expediente).

## Declaración de asistencia de Inteligencia Artificial

Seguimos el mismo criterio ya declarado en
[`CONTRIBUTORS.md`](CONTRIBUTORS.md#declaración-de-asistencia-de-inteligencia-artificial):
el cierre de estos pendientes usó Claude (Anthropic) como herramienta de
apoyo — para leer y contrastar la guía contra el repositorio, redactar
`VERIFICACION.md`, corregir el script de cobertura de Javadoc y verificar
individualmente las 15 constancias de consentimiento. Cada commit se
revisó y se hizo bajo la identidad y responsabilidad de la persona que
firma más abajo; ningún commit incluye atribución de coautoría a IA.

## Firmas

Cada integrante confirma que la atribución de arriba es correcta y que
puede defender ante el docente el código y la evidencia de los puntos que
declara suyos.

| Integrante | Correo institucional | Conforme |
|---|---|---|
| Arcalle Grefa Darwin Orlando | darcalleg@uteq.edu.ec | Sí (2026-09-16); **renovada el 2026-09-21** por los cierres del 19 al 21/09 |
| Pallo Pinto Alejandro Daniel | dpallop@uteq.edu.ec | Sí (2026-09-16). Salió del proyecto: **no renueva** y no se firma por él |
| Velez Lopez Ricardo Elias | rvelezl3@uteq.edu.ec | Sí (2026-09-16); **requiere re-firma** — declara `9810639e` (P7 puede fallar, Drive P13) |

**Re-firma de Arcalle Grefa Darwin Orlando (2026-09-21), registrada por su
indicación expresa.** Confirma que la atribución de arriba es correcta y que
puede defender ante el docente el código y la evidencia de sus puntos,
incluidos los cierres posteriores al 2026-09-16, contrastados contra
`git log`: `f2c0f11` y `885ee69` (P3, P13, P11, P4, P10, P8, P2, con el
correo personal declarado en `.mailmap`), `86902a0`, `273f347`, `20135de`
y `fbe19fc` (P4, P8, P12, P1, P10, P2, con el correo institucional).
También responde por dos commits que retiró él mismo: `634fe7a` y
`4b73b7d` subieron `docs/defensa/DEFENSA.md`, un guion que no debía estar
en el repositorio y que `fbe19fc` retira (ver «21-sep (2), retirado»).

**Pallo Pinto Alejandro Daniel** salió del proyecto: no renueva su
conformidad y no se le atribuye trabajo posterior a su salida ni se firma
en su nombre; la del 2026-09-16 se limita a los commits suyos que verificó
entonces (más abajo).

**Velez Lopez Ricardo Elias** sigue pendiente: debe confirmar por sí mismo
que declara suyo `9810639e` (P7 endurecido + verificación de acceso del
Drive) y que su conformidad del 2026-09-16 sigue vigente. Ninguna firma se
extiende por otro integrante.

_Pallo Pinto confirmó su conformidad el 2026-09-16, verificando contra
`git log` los commits que se le atribuyen en P2 (`9f75e71`), P10
(`ebb5906`), P12 (`76e4e48`) y P14 (`734a79f`, `7ce1474`): los cinco
corresponden a `Alejandro-hub19 <dpallop@uteq.edu.ec>`. Arcalle Grefa
confirmó su conformidad el 2026-09-16 sobre los puntos que se le
atribuyen como titular del cierre (P1, P3, P5, P6, P7, P8, P9, P10,
P11, P12, P13, P14), el cierre específico de P4 (`e666d41`, `39ca9fa`)
y sobre EV-1/EV-2/EV-3. Velez Lopez confirmó su
conformidad el 2026-09-16, verificando contra `git log` los commits que
se le atribuyen en P1 (`d973292`, amenazas a la validez en
`docs/mediciones/sus/REPORT.md`) y P13 (`fb08831`, plantilla de
consentimiento `docs/etica/consentimiento/plantilla.md`): ambos
corresponden a `Ricardo Elías Vélez López <rvelezl3@uteq.edu.ec>`, y
confirma además la atribución de P13 — contactó a los 15 participantes
reales de la encuesta SUS y firmó como investigador responsable en las
15 constancias._

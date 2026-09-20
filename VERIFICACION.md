# Expediente de verificación (EV-1)

Guía del examen suspenso, UTEQ — Aplicaciones Web, PPA 2026-2027.
Por cada uno de los 14 pendientes: identificador, orden exacta, salida
pegada tal cual (corrida el 2026-09-14/15 sobre el commit indicado abajo)
y ruta del archivo que la respalda.

**Cómo reproducir todo de una vez:** `make verify` (equivalente a
`bash scripts/verify.sh`). Ese objetivo es EV-2: se puede correr entero
desde un clon limpio y su código de salida es 0 solo si todo pasa.

Este expediente es un documento vivo: se actualiza en cada commit que
cierra o corrige un punto, no en un único corte congelado. La orden y
la salida pegadas en cada sección son literales de cuando se escribió
esa sección (fecha citada ahí mismo); para el estado agregado vigente,
la fuente de verdad es correr `bash scripts/verify.sh` sobre el commit
que señale `git rev-parse v1.1.0^{commit}` en ese momento, no un hash
fijo escrito aquí arriba — esta misma línea citó primero `7f6f424` y
luego `0ecf27a3`, ninguno de los dos el commit vigente en ningún
momento en que alguien la leyó (defecto señalado por la evaluación v2
del 17-sep).

> **Nota de método.** Varios de los 14 pendientes que describe la guía ya
> tenían trabajo sustantivo hecho en el repositorio al momento de escribir
> este expediente (ver detalle en cada punto). Donde eso ocurre, lo digo
> explícitamente con la orden y la salida real que lo demuestra, en vez de
> asumir que hay que rehacerlo. Lo que de verdad falta queda marcado como
> **FALTA** con la orden que lo va a comprobar una vez cerrado.

## EV-2 — Endurecimiento contra mutaciones (2026-09-17)

La evaluación integral del examen suspenso corrió 13 mutaciones
deliberadas contra `scripts/verify.sh` (romper una fila real de la
matriz, agregar filas basura al CSV del SUS, apuntar Lighthouse a
`localhost`, quitar el MoSCoW de un requisito, borrar `@param`/`@return`,
agregar clases en español, crear una segunda etiqueta, frases de "60%"
con otra redacción, alterar p-valores en el REPORT): 11 de 13 pasaron
cuando deberían haber fallado. El defecto de fondo, repetido en varios
puntos: los chequeos confirmaban que *algo con la forma correcta existe*
(un archivo, una cuenta ≥ N, una palabra clave), no que el *contenido*
fuera el correcto.

Endurecido en esta ronda (verificado reproduciendo cada mutación exacta
y confirmando que ahora `bash scripts/verify.sh` falla, luego
restaurando el archivo):

| Punto | Mutación que antes pasaba | Chequeo nuevo |
|---|---|---|
| P1 | Agregar filas basura al CSV (el conteo ">=15" no distingue basura de datos reales) | Valida forma de cada fila: 21 columnas, `participante` con forma `ENC-NN`, `p1`..`p10` enteros 1-5 |
| P2 | Cambiar el `requestedUrl` de una corrida de Lighthouse a `localhost` (con 9+9 corridas archivadas, sobran para seguir pasando el umbral de "≥3 válidas") | Exige que **todas** las corridas encontradas sean válidas, no solo ≥3 |
| P7 | Quitar el MoSCoW de un requisito puntual (79 de 80 sigue siendo ">0") | Verifica requisito por requisito que cada uno (salvo los 2 contenedores declarados, RF-19/RNF-23) tenga su propia línea `MoSCoW:` |
| P8 | Crear una segunda etiqueta cualquiera (el chequeo solo confirmaba que `v1.1.0` existe, nunca que fuera la única activa) | Enumera todas las etiquetas del repo y falla si aparece alguna fuera de la lista histórica declarada en `VERSIONING.md` |
| P10 | La tabla resumen de roles puede desincronizarse de la tabla de conteo real sin que nada lo note (así estaba: a Arcalle le faltaba `Writing – review & editing` con el conteo más alto de los tres) | Cruza programáticamente ambas tablas de `CONTRIBUTORS.md`; falla si a alguien le falta en su lista un rol con conteo > 0 |
| P14 | Editar a mano un p-valor en `REPORT.md` (los chequeos solo confirmaban que la tabla existe) | Regenera `REPORT.md` desde los `*.samples.json` reales y lo compara contra el versionado, ignorando las 3 líneas de metadato que cambian por diseño (Fecha, Commit, Herramienta) |

**No endurecido, declarado como límite conocido (no oculto):**
- **P4** (borrar todos los `@param`/`@return`): requeriría parsear la firma de cada método para saber cuántos `@param` esperar — no se hizo por el riesgo de un parser frágil bajo el plazo del examen suspenso. Ya está declarado en la sección P4 de este documento que el `pom.xml` usa `doclint all,-missing`, que desactiva justo esa detección.
- **P9** (agregar clases en español fuera del diccionario heurístico): el chequeo es, por diseño, un diccionario fijo de palabras — no puede enumerar todo el español. Por eso P9 ya queda marcada `PENDIENTE (revisión manual)` en `scripts/verify.sh`, no solo automática.
- **P3, P6**: ya se habían endurecido en la ronda anterior (16/17-sep); las mutaciones de la evaluación integral sobre estos puntos (DOI, figuras) no encontraron nada nuevo que esa ronda no cubriera.
- **P12: esta afirmación era falsa** hasta que la evaluación v2 (17-sep, más tarde el mismo día) la refutó probando 4 redacciones nuevas del hecho falso sobre el umbral; 3 sobrevivían al patrón existente. Corregido en la sección de P12 más abajo — ancla ampliada más allá de la palabra "umbral" y agregada la forma entera con el símbolo de porcentaje (antes solo se reconocía la forma decimal).

Después de este endurecimiento, `bash scripts/verify.sh` tiene 5
aserciones nuevas (P1, P7, P8, P10, P14; P2 se hizo más estricta sin
agregar una aserción nueva) y pasa de **26/0/2** a **29/1/2**
(pasan/fallan/manual). El único fallo nuevo es real y esperado: el
chequeo endurecido de P7 (más abajo) ahora exige que el acta firmada
cubra la versión vigente del SRS, y ese día no la cubría — antes pasaba
en falso. `make verify` no volvió a salir en verde hasta que el
docente-director confirmó, el 2026-09-18, que la firma de la v1.8 sigue
vigente (ver P7 más abajo) — un fallo real, resuelto por la vía real
(la palabra del docente, no un ajuste del script), no maquillado ni
ignorado mientras tanto.

---

## P1 — Respuestas del SUS (peso 1,3)

**Orden:**
```bash
n=$(($(wc -l < docs/mediciones/sus/respuestas.csv) - 1)); echo "participantes: $n"
grep -i "brooke" docs/mediciones/sus/REPORT.md
grep -i "t de Student" docs/mediciones/sus/REPORT.md
```

**Salida:**
```
participantes: 15
- Instrumento: System Usability Scale (Brooke, 1996), 10 items, escala 1-5
- Brooke, J. (1996). *SUS: A quick and dirty usability scale.*
- Metodo del IC | t de Student, gl=14, t=2.145
```

**Respalda:** [`docs/mediciones/sus/respuestas.csv`](docs/mediciones/sus/respuestas.csv), [`docs/mediciones/sus/REPORT.md`](docs/mediciones/sus/REPORT.md), [`docs/mediciones/sus/INTERPRETACION.md`](docs/mediciones/sus/INTERPRETACION.md)

**Estado:** hecho. Los 15 registros reales, el recálculo Brooke y el IC 95%
con t de Student ya estaban hechos; el consentimiento de cada participante
que bloqueaba este punto se cerró en P13 (2026-09-14/15) — ver esa
sección.

---

## P2 — Lighthouse (peso 0,9)

**Orden:**
```bash
bash scripts/verify.sh 2>&1 | grep -A3 'P2 --'
```

**Salida:**
```
== P2 -- Lighthouse: 3 corridas por perfil contra el despliegue publico ==
  PASA: 9/9 corridas moviles + 9/9 de escritorio con requestedUrl=https://sged-frontend-r2rs.onrender.com/ (todas validas)
  PASA: REPORT.md documenta la medición vigente contra r2rs
```

(Corrección 2026-09-16: la versión anterior contaba
`mobile-run*`/`desktop-run*` — que son locales
(`host.docker.internal:8443`) — mientras afirmaba despliegue público.
Las corridas `public-*-2026-09-08` apuntan a `sged-frontend-jofa`,
sufijo anterior; se conservan como bitácora fechada.)

**Corrección 2026-09-16 (más tarde el mismo día):** se agregaron las 12
corridas autenticadas contra `/dashboard` e `/inventario` en `r2rs`
(`public-{mobile,desktop}-{dashboard,inventario}-run{1,2,3}.report.json`),
con `LH_USER`/`LH_PASS` reales y `scripts/lighthouse-ci.mjs` sin
modificar. Estas — no la medición de la portada del mismo día — son la
evidencia vigente, porque miden las pantallas reales de la aplicación:

| Perfil | Ruta | Rendimiento (3 corridas) | Media | Estado |
|---|---|---|---|---|
| Móvil | `/dashboard` | 84 / 87 / 87 | 86,0 | ✅ ≥ 80 |
| Móvil | `/inventario` | 100 / 100 / 100 | 100,0 | ✅ ≥ 80 |
| Escritorio | `/dashboard` | 77 / 84 / 77 | **79,3** | ⚠️ < 80 |
| Escritorio | `/inventario` | 100 / 100 / 100 | 100,0 | ✅ ≥ 80 |

**Escritorio/`/dashboard` (79,3) quedó por debajo del umbral de 80.**
No era un empate en el umbral ni un artefacto del entorno de medición
(a diferencia de la corrida de la portada, esa no usó renderizado por
software): era un resultado real y reproducible. Diagnosticado con
`cls-culprits-insight` del LHR: CLS = 0,689, atribuido en un 88% a
`app-mapa-asistencia` desplazándose ~208px. Medido con el navegador
contra la app en vivo, la causa real era `app-graficos-ingresos`
(405px) apareciendo sin espacio reservado justo arriba, al resolver
`/api/pagos/ingresos-historico` y `/api/alertas` — empujaba el mapa
hacia abajo, y Lighthouse atribuía el desplazamiento al elemento
empujado, no al que empujaba.

**Corrección 2026-09-17 (código):** en
[`dashboard.component.ts`](frontend/src/app/features/dashboard/dashboard.component.ts),
tanto `app-graficos-ingresos` como `app-mapa-asistencia` ahora reservan
su alto real (405px y 208px) con un marcador de carga mientras el dato
no llega, en vez de aparecer de la nada. Desplegado en `r2rs` y
re-medido (12 corridas nuevas):

| Perfil | Ruta | Rendimiento (3 corridas) | Media | Estado |
|---|---|---|---|---|
| Móvil | `/dashboard` | 98 / 100 / 100 | 99,3 | ✅ ≥ 80 |
| Móvil | `/inventario` | 99 / 100 / 100 | 99,7 | ✅ ≥ 80 |
| Escritorio | `/dashboard` | 100 / 100 / 100 | **100,0** | ✅ ≥ 80 |
| Escritorio | `/inventario` | 100 / 100 / 100 | 100,0 | ✅ ≥ 80 |

CLS de escritorio/`/dashboard` pasó de 0,689 a 0 (score 1). Ya no hay
ningún hallazgo abierto en P2. Pendiente, fuera de este fix:
`.panel-alertas` (debajo del mapa, hasta 1059px con muchos estudiantes
en riesgo) también aparece sin reserva, pero su alto es inherentemente
variable — no se le puso una cifra fija adivinada. Ver
`docs/mediciones/lighthouse/REPORT.md` para el detalle completo
(accesibilidad, buenas prácticas y SEO de las cuatro combinaciones, en
ambas corridas).

**Corrección 2026-09-16 (script):** `scripts/verify.sh` contaba "3
corridas móviles + 3 de escritorio" en vez de las 9 de cada una
(portada + dashboard + inventario) porque en Windows `python3` abría
los JSON con la codificación por defecto del sistema (`cp1252`) en vez
de UTF-8; los reportes de `/dashboard`/`/inventario` (que sí incluyen
texto no-ASCII de la interfaz) fallaban a decodificar y se contaban
como "no coincide", silenciado por el `2>/dev/null` del script. El
resultado (`PASA`, ≥3 de cada uno) no cambiaba porque igual sobraban
corridas válidas, pero era un defecto de portabilidad del script en
Windows. Corregido en el mismo commit: ambos `open()` de
`scripts/verify.sh` ahora pasan `encoding='utf-8'` explícito.

**Respalda:** [`docs/mediciones/lighthouse/`](docs/mediciones/lighthouse/) (18 LHR contra r2rs: portada + dashboard + inventario, más bitácoras locales y jofa fechadas), [`dashboard.component.ts`](frontend/src/app/features/dashboard/dashboard.component.ts)

**Estado:** hecho. Las cuatro combinaciones perfil×ruta cumplen los tres umbrales del Bloque A.1.

---

## P3 — DOI retirado (peso 0,5)

**Corrección 2026-09-19: el DOI retirado ya no se declara.** El criterio
de la guía es "todos los DOI declarados resolviendo a 200". Citar el
depósito retirado, aunque fuera advirtiendo que estaba retirado, seguía
siendo declararlo, y no puede resolver a 200: Zenodo lo dio de baja
(*tombstone*, HTTP 410) porque se había publicado como registro
independiente y no como nueva versión de la serie del concept DOI
`10.5281/zenodo.21713239`, error que se corrigió publicando la serie
vigente (`22714477`, `22730565` y `22739944`). Se retiró de `README.md`,
`CITATION.cff`, `docs/informe/main.tex` (y su PDF), `docs/checklists/fair.md`
y `docs/observaciones/OBSERVACIONES.md`; el motivo queda explicado, sin
el identificador, en `CHANGELOG.md`, `README.md` y `main.tex`. El
historial de git conserva el DOI y su corte (`v1.0.1`). `scripts/check-doi.sh`
ya no tiene un caso especial: exige 200 en todos los DOI de Zenodo
citados, y **falla** si el DOI retirado vuelve a aparecer en alguna cita
(comprobado por mutación: añadir la cita a `CHANGELOG.md` → `FAIL`,
código 1).

**Corrección 2026-09-16:** `scripts/check-doi.sh` solo revisaba
README.md/CITATION.cff (2 archivos) y no tocaba la bibliografía —
exactamente el hueco que señalaba la revisión, porque `main.tex` cita
tanto el DOI retirado como `zenodo.21713240` y ninguno de los dos
pasaba por el script. Reescrito para que:
1. busque DOI de Zenodo en **todo el repositorio versionado**
   (`git grep` sobre `*.md`/`*.tex`/`*.cff`), no solo en 2 archivos;
2. para el DOI retirado, exija 410 **y** que todos los archivos que lo
   citan digan explícitamente que está retirado (no solo README.md);
3. revise también los 27 DOI de [`docs/informe/referencias.bib`](docs/informe/referencias.bib),
   aceptando 200, 403 (bloqueo de editorial a clientes automatizados) o
   202 (mismo bloqueo, pero así responde IEEE Xplore — verificado que
   el redirect llega a un documento real).

**Corrección crítica 2026-09-18: `make verify` no era determinista.**
La evaluación del 18-sep encontró el defecto que decidía la nota: la
línea `code=$(curl ... -w "%{http_code}" ... || echo "000")` podía
dejar escrito el código de un salto de la redirección (ej. "302") antes
de que `curl` agotara el tiempo (Zenodo tardaba 4,3–15 s, cerca del
límite de 20 s de entonces), y el `|| echo "000"` lo **concatenaba** en
vez de reemplazarlo — "302000" no es "200" ni "410", así que un DOI que
sí resolvía se marcaba como fallo. El efecto real: `bash scripts/verify.sh`
podía salir en 0 u 1 en corridas distintas del mismo commit, sin que
nada hubiera cambiado — la nota dependía de la suerte de la red esa
noche, no del estado real del repositorio. Corregido con una función
`resolver_doi()` que descarta explícitamente cualquier salida parcial
cuando `curl` termina con código de error (la reemplaza por "000", nunca
la concatena), sube el límite a 30 s y agrega 2 reintentos. Verificado
con 3 corridas seguidas de `make verify` completo (30/0/2, exit 0 las
tres) y forzando un timeout artificial de `curl` para confirmar que ya
no se concatena nada.

**Orden:** `bash scripts/check-doi.sh`

**Salida (resumen; ver `scripts/check-doi.sh` para la lista completa):**
```
== DOI de Zenodo citados en el repositorio ==
OK   10.5281/zenodo.21713239 -> 200
OK   10.5281/zenodo.21713240 -> 200
OK   10.5281/zenodo.22422305 -> 200
OK   10.5281/zenodo.22714477 -> 200
OK   10.5281/zenodo.22730565 -> 200
OK   10.5281/zenodo.22739944 -> 200

== DOI de la bibliografia (docs/informe/referencias.bib) ==
(27/27 OK: 19 resuelven 200, 7 bloquean con 403 a clientes
automatizados -- editoriales conocidas -- y 1 con 202 de IEEE Xplore,
redirect verificado a un documento real: 10.1109/msr66628.2025.00020)
```

**Nota sobre disponibilidad:** al intentar esta verificación más
temprano el mismo día, Zenodo devolvía 504 (Gateway Timeout) de forma
consistente -- una caída real de su servidor, confirmada por dos vías
de red distintas, no un DOI roto. Se reintentó más tarde con éxito.

**Respalda:** [`scripts/check-doi.sh`](scripts/check-doi.sh), [`README.md`](README.md), [`CITATION.cff`](CITATION.cff), [`docs/informe/main.tex`](docs/informe/main.tex), [`docs/informe/referencias.bib`](docs/informe/referencias.bib)

**Estado:** hecho. Los 6 DOI de Zenodo citados en el repositorio
resuelven a 200 y los 27 de la bibliografía resuelven según lo
esperado; el DOI retirado ya no se cita en ningún documento y el
verificador lo vigila.

---

## P4 — Javadoc (peso 1,5)

**Orden:**
```bash
python3 scripts/javadoc-coverage.py 90
cd backend && ./mvnw -q javadoc:javadoc; echo "exit=$?"
```

**Salida:**
```
Metodos/constructores publicos encontrados: 503
Con Javadoc con texto inmediatamente encima: 503
Completos (@param por parametro y @return si devuelve): 502
Cobertura: 100.0%  Completitud: 99.8%  (umbral exigido: 90%)
RESULTADO: PASA

exit=0
```

(Corrección 2026-09-16: la cifra 612/612 de la versión anterior del
expediente estaba inflada — el script contaba 102 declaraciones
`public record X(...)` como métodos (su regex de tipos no incluía
`record`) y 7 miembros de `@interface` (elementos de anotación, no
métodos). Corregido `scripts/javadoc-coverage.py`: excluye
declaraciones `record` y cuerpos de `@interface`. El conteo
independiente de la revisión (506 métodos, 506 documentados, 499
completos con `@param`/`@return` = 98,6 %) difiere en ±3 por criterio
(constructor compacto sin paréntesis, casos límite de firma
multipartida); con cualquier criterio la cobertura es 100 %.)

**Corrección 2026-09-19 (el verificador no podía fallar por contenido):**
la evaluación final mostró dos mutaciones que seguían dando "503/503,
100 %": borrar todos los `@param`/`@return` del backend y vaciar todo el
Javadoc a `/** . */`. El criterio de la guía es Javadoc completo y el
script solo comprobaba que existiera un bloque. Ahora exige (a) texto
real dentro del bloque y (b) un `@param` por parámetro y un `@return` si
el método devuelve algo, cada uno con el mismo umbral. Repetidas ambas
mutaciones sobre una copia: la primera da Cobertura 73,2 % y
Completitud 0,2 % → `FALLA`, código 1; la segunda da 0,4 % → `FALLA`,
código 1. Sobre el código real: 503/503 con texto y 502/503 completos
(99,8 %).

**Respalda:** [`scripts/javadoc-coverage.py`](scripts/javadoc-coverage.py)

**Estado:** hecho, con margen real (100 %, no un 90,03 % al límite).

El 90,03% que reportaba la corrida anterior (551/612) era un defecto del
propio script de conteo, no del código: `is_documented()` subía desde la
firma del método saltando líneas en blanco y anotaciones de una sola
línea, pero **no sabía seguir una anotación partida en varias líneas**
(ej. `@Audited(..., descriptionSpel = "...")` con el segundo argumento en
su propia línea) ni saltar un comentario `//` suelto entre el Javadoc y
las anotaciones (ej. la nota que justifica un `@CacheEvict` puntual). En
ambos casos la línea de continuación no empieza con `@` ni es un
comentario de bloque, así que el script paraba ahí y daba el método por
no documentado aunque el Javadoc real estuviera dos o tres líneas más
arriba.

Antes de tocar el script comprobé, método por método, los 61 casos que
reportaba `docs/mediciones/javadoc-sin-documentar.txt` (revisando el
código fuente directamente, no fiándome del conteo): 60 de los 61 **ya
tenían Javadoc real y completo** (con `@param`/`@return`/`@throws`), solo
oculto por alguno de los dos patrones de arriba. Un caso también apareció
duplicado dos veces de forma idéntica en
[`ConsentRepository.java`](backend/src/main/java/org/uteq/backend/academico/guardian/repository/ConsentRepository.java)
(defecto real, no de conteo) — se eliminó la copia sobrante. El único
método genuinamente sin documentar era el constructor compacto del record
[`AnonymousPlayerProfile`](backend/src/main/java/org/uteq/backend/common/ia/AnonymousPlayerProfile.java) (el propio record ya tenía Javadoc con
`@param` por campo, pero el constructor compacto que valida y normaliza
esos campos no tenía el suyo) — se le agregó.

Corregido `is_documented()` en `scripts/javadoc-coverage.py` para que
reconozca ambos patrones (clasifica el bloque de líneas de arriba hacia
abajo primero, para saber dónde abre y cierra una anotación multilínea, y
después lo recorre hacia atrás) y se re-corrió: **503/503 métodos
públicos documentados, 100,0%**. `docs/mediciones/javadoc-sin-documentar.txt`
se eliminó porque ya no hay ningún método sin Javadoc que listar.

El conteo de 463 métodos que cita la guía sigue sin coincidir con los 503
que encuentra este script — puede ser un criterio de "método público" más
estricto del docente (ej. excluir getters/setters de Lombok, DTO record,
o métodos de repositorios Spring Data) — pero con 100% no hay margen que
perder aunque el criterio del docente cuente menos métodos: si su lista
es un subconjunto de estos 503, sigue estando al 100% documentada.

---

## P5 — Validador de trazabilidad (peso 0,6)

**Orden:**
```bash
TMP_DEMO="$(mktemp -d)" && cp docs/trazabilidad/matriz.csv "$TMP_DEMO/rota.csv" \
  && echo 'RF-DEMOSTRACION,CRUD-ORM,fila deliberadamente sin trazabilidad,,,GET /api/nada,backend/Nada.java,,,Planificado,' >> "$TMP_DEMO/rota.csv" \
  && bash scripts/validate-traceability.sh "$TMP_DEMO/rota.csv"; echo "exit=$?"; rm -rf "$TMP_DEMO"
bash scripts/test-validate-traceability.sh; echo "exit=$?"
```

**Salida:**
```
VIOLACIÓN: RF-DEMOSTRACION no tiene historia, caso de uso ni prueba.
VIOLACIÓN: la matriz (RF-DEMOSTRACION, archivo_implementacion) cita la ruta backend/Nada.java pero no existe en el repositorio.
VIOLACIÓN: ids de la matriz sin requisito en el SRS: RF-DEMOSTRACION
exit=1
OK: el validador falla-cerrado ante fila sin trazabilidad (codigo 1), referencia inexistente (codigo 1), columnas mal contadas (codigo 1), estado fuera del vocabulario (codigo 1) y ruta inexistente citada en el SRS (codigo 1).
exit=0
```

(Corrección 2026-09-16: la versión anterior del expediente mostraba
una orden con rutas inexistentes y la salida recortada con `[...]`;
arriba está la ruptura real de una fila y la salida íntegra.)

**El criterio literal de la guía — "romper una fila real de la matriz
hace fallar `make verify`" — con una fila real, no sintética:**

```bash
bash scripts/test-verify-fails-on-real-row.sh
```

```
== docs/trazabilidad/matriz.csv real, con RF-01 corrompida in situ ==
== corriendo 'bash scripts/verify.sh' completo (make verify) ==

OK: romper la fila real RF-01 (prueba_automatizada -> metodo inexistente)
    hace fallar 'bash scripts/verify.sh' con codigo de salida 1.

-- fragmento relevante de la salida de verify.sh --
== P5 -- validate-traceability.sh propaga el codigo de salida ==
  FALLA: docs/trazabilidad/matriz.csv (la matriz real) tiene violaciones: VIOLACIÓN: la matriz cita ClaseQueNoExisteTest.metodoFantasma pero no existe la clase de prueba ClaseQueNoExisteTest.
  PASA: el validador imprime la VIOLACIÓN y sale con codigo 1 ante fila rota real
  FALLA: scripts/test-validate-traceability.sh falla
```

El script corrompe la columna `prueba_automatizada` de `RF-01` (fila
real del proyecto, no inventada), corre `bash scripts/verify.sh`
completo contra ese archivo, confirma el fallo, y restaura el original
—`docs/trazabilidad/matriz.csv` queda intacto al terminar—.

(Nota 2026-09-17: la evaluación integral señaló que la prueba anterior
solo agregaba una fila sintética a una *copia*, y nunca mostraba
`make verify` fallando sobre el archivo real. Dos correcciones: (a)
`scripts/verify.sh` ahora valida también `docs/trazabilidad/matriz.csv`
tal cual está en el repositorio, sin copias — antes nunca miraba el
archivo real, solo probaba que el validador *sabe* detectar filas
rotas en copias; (b) se agregó `scripts/test-verify-fails-on-real-row.sh`,
que corrompe una fila real y lo demuestra end-to-end. No se integró
dentro de `scripts/verify.sh` porque este ya invoca a
`scripts/test-validate-traceability.sh`, y ese script a su vez invoca a
`verify.sh` completo — crearía recursión infinita.)

**Respalda:** [`scripts/validate-traceability.sh`](scripts/validate-traceability.sh) (usa `exec`, por lo que ya propaga el código de salida de `validate-traceability.py`), [`scripts/test-verify-fails-on-real-row.sh`](scripts/test-verify-fails-on-real-row.sh)

**Estado:** hecho. El script sí falla con código distinto de cero; el
defecto real era que nada lo invocaba automáticamente sobre el archivo
real — `make verify` ahora lo hace en cada corrida, y el script de
arriba demuestra el caso extremo (fila real rota) end-to-end.

---

## P6 — Figuras en inglés (peso 0,7)

**Orden:** ver la sección `P6` de `scripts/verify.sh` (barrido de
`docs/diagramas/*.md` dentro de los bloques ```mermaid```, `docs/diagramas/*.svg`
y `docs/arquitectura/workspace.dsl` contra un diccionario de términos en
español).

**Salida:**
```
PASA: sin coincidencias del diccionario de terminos en español dentro de mermaid/svg/dsl
```

**Respalda:** [`docs/diagramas/diagrama-clases.md`](docs/diagramas/diagrama-clases.md), [`docs/diagramas/mer-profutbol.svg`](docs/diagramas/mer-profutbol.svg), [`docs/arquitectura/workspace.dsl`](docs/arquitectura/workspace.dsl)

**Estado:** hecho. Las fuentes de las figuras (Mermaid, SVG del MER, DSL de
C4) ya estaban en inglés. Revisión manual completada el 2026-09-15
(actualizada 2026-09-17 tras contar de nuevo: la versión anterior decía
"10", una cuenta corta por uno; son 11): se abrieron a simple vista los
**11 PNG** rasterizados que el grep no puede cubrir
(`docs/arquitectura/L1-contexto.png`, `L2-contenedores.png`,
`L3-academico.png`, `L3-deportivo.png`, `L3-seguridad.png`, `L3-componentes.png`,
`docs/diagramas/mer-academico.png`, `mer-deportivo.png`, `mer-inventario.png`,
`mer-seguridad.png`, `mer-profutbol.png`) — los once
están 100% en inglés (títulos, entidades, atributos y notas), sin ningún
término en español.

**Aclaración 2026-09-16 sobre identificadores del sistema en figuras:**
toda la prosa de las figuras está en inglés; los únicos tokens en español
que pueden verse son identificadores reales del sistema que las figuras
citan textualmente y no se pueden traducir sin falsear el diagrama:
esquemas BD (`academico`, `deportivo`, `seguridad`), rutas de la API
(`/api/estudiantes`, `/api/categorias`, `/api/entrenadores`), la columna
`rfid_codigo` y procedimientos (`sp_contar_estudiantes_activos`).
Traducirlos en el dibujo rompería la correspondencia figura↔código que
exige la trazabilidad.

**Actualización 2026-09-16 — PDF regenerado:** `docs/informe/main.pdf`
y `docs/informe-final.pdf` regenerados con TeX Live local (72 páginas,
0 errores, 0 referencias sin resolver) para que el PDF versionado
incluya el C4 L3 vigente y el resto de cambios posteriores a la última
regeneración.

**Actualización 2026-09-16 — diagramas grandes divididos por módulo
(pedido del docente, fuera de los 14 puntos numerados).** El MER
completo (35 tablas en un solo lienzo) y el C4 nivel 3 (25 componentes
de 3 dominios en un solo lienzo) eran ilegibles como diagrama único. Se
mantienen como registro (`mer-profutbol.png`, `L3-componentes.png`) y se
agregan divididos por módulo: `mer-seguridad/academico/deportivo/
inventario.png` (uno por esquema real de PostgreSQL) y
`L3-seguridad/academico/deportivo.png` (uno por dominio). Los 8 PNG
nuevos están en inglés (mismo criterio que los anteriores) y se
verificaron visualmente al generarlos, no solo por grep.

De paso, al reconstruir el MER contra `db/schema.sql` (la fuente real)
para poder dividirlo con exactitud, se encontró que la versión anterior
de `mer-profutbol.dbml` modelaba solo 25 de las 35 tablas reales y
predataba varias funcionalidades (cuentas de usuario como entidad
propia, todo el módulo de representantes/consentimiento, categorías
como tabla, movimientos de stock de inventario). El archivo completo se
regeneró para reflejar las 35 tablas reales; no es un cambio pedido por
la guía del examen suspenso (el MER no aparece en los 14 puntos) pero sí
corrige un dato desactualizado que convenía no dejar pasar.

**Defecto real señalado por la evaluación integral (17-sep) y corregido:**
los 8 PNG divididos por dominio/módulo se generaron el 16-sep, pero
`docs/informe/main.tex` seguía imprimiendo el lienzo único
`L3-componentes.png` (letra de 2–3\,pt, ilegible) — la división existía
como archivo, pero nunca se conectó al informe. Corregido: la
sección~3.4 del informe ("Vista de componentes (C4 nivel 3)") ahora
imprime las tres figuras por dominio (`L3-seguridad.png`,
`L3-academico.png`, `L3-deportivo.png`), cada una a ancho de página
completo; `L3-componentes.png` se conserva en el repositorio como
referencia, mencionada en el texto pero sin imprimirse. PDF regenerado
(74 páginas, 0 errores, 0 referencias sin resolver).

---

## P7 — SRS firmado, con MoSCoW (peso 0,8)

**Orden:**
```bash
bash scripts/verify.sh 2>&1 | grep -A3 'P7 --'
```

**Salida:**
```
== P7 -- SRS firmado, versionado y con MoSCoW ==
  80 requisitos evaluables (excluye 2 contenedores); faltan MoSCoW: []
  PASA: cada requisito individual del SRS trae su propio MoSCoW explicito
  PASA: acta de aprobacion firmada por el docente-director existe (docs/requisitos/ACTA-APROBACION-SRS-v1.8.pdf); confirmo por escrito (SRS.md) que sigue vigente sin necesidad de una firma nueva
  PASA: docs/requisitos/SRS-v1.1.0.pdf existe
```

**Respalda:** [`docs/requisitos/SRS.md`](docs/requisitos/SRS.md), [`docs/requisitos/ACTA-APROBACION-SRS-v1.8.pdf`](docs/requisitos/ACTA-APROBACION-SRS-v1.8.pdf)

**Estado:** hecho. MoSCoW, el PDF versionado y la firma vigente están
cerrados (ver más abajo). `docs/requisitos/SRS-v1.1.0.pdf` existe (64 páginas),
generado con un pipeline nuevo y reproducible:
[`scripts/build-srs-pdf.sh`](scripts/build-srs-pdf.sh) / `make srs` —
Markdown → HTML autocontenido (`pandoc --embed-resources`, incrusta las
firmas como *data URI*) → PDF (`WeasyPrint`, motor de render HTML/CSS
real, con `fonts-noto-color-emoji` instalado).

**Por qué no el mismo pipeline que el informe (`pdflatex`):** el primer
intento (`pandoc` apuntado directo a LaTeX/`xelatex`, como `make docs`)
no era confiable: (a) los emoji de estado ✅/⬜ no tienen glifo en las
fuentes de LaTeX por defecto y salían en blanco, y (b) las tres firmas
embebidas con `<img src="firmas/...">` (HTML crudo) se pierden al
renderizar a LaTeX — el archivo de prueba salió de 204&nbsp;KB contra
1,98&nbsp;MB del `SRS.pdf` original, señal de que las firmas no
entraron. Verificado visualmente rindiendo páginas del PDF final a PNG
(`pdftoppm`): las tres firmas se ven completas y el ✅ sale con su
glifo real, en color.

No hay evidencia de qué herramienta generó el `SRS.pdf`/`SRS-v1.0.0.pdf`
originales (sin target de Makefile ni script versionado antes de esto);
`scripts/build-srs-pdf.sh` deja ese proceso reproducible de ahora en
adelante. `docs/requisitos/SRS.pdf` (la copia "viva", sin versión en el
nombre) también se regeneró con el mismo comando, porque estaba
desactualizada desde el 2026-09-12 (le faltaban los cambios de URL del
repositorio y de etiqueta de los commits de esta sesión).

**Historia de este punto — de "pendiente real" a cerrado, sin firma
nueva.** Tanto la guía original como la evaluación integral y la v2
señalaron lo mismo: el acta firmada por el docente-director
(`ACTA-APROBACION-SRS-v1.8.pdf`) aprueba explícitamente la v1.8, y el
propio acta exige volver a someter el documento si cambia — y el SRS
vigente ya es la v1.11. `scripts/verify.sh` primero solo comprobaba que
existiera *algún* acta firmada (pasaba con cualquier versión vieja);
se corrigió el 2026-09-17 para exigir el acta con el número exacto de
la versión vigente en el nombre, y correctamente reportó
`PENDIENTE (revisión manual)` durante un día — la verdad era que no
existía firma para v1.11.

**Resuelto el 2026-09-18: el docente-director confirmó directamente al
equipo que la firma de la v1.8 sigue vigente y que no hace falta una
firma nueva** para las divergencias declaradas (RF-11c y la traducción
de 4 enums, ambas ya documentadas en el propio SRS desde antes). Esa
confirmación queda escrita en `docs/requisitos/SRS.md` (nota
"Confirmación del docente-director (2026-09-18)", junto a la tabla de
firmas, §7) — no es una excepción silenciosa: `scripts/verify.sh` exige
literalmente que esa nota exista en el SRS para aceptar el acta
existente como vigente; si algún día se borrara esa nota sin que el
docente realmente lo haya confirmado, el chequeo volvería a fallar.

---

## P8 — Etiqueta única v1.1.0 (peso 0,6)

**Orden:**
```bash
test "$(git rev-parse 'v1.1.0^{commit}')" = "$(git rev-parse HEAD)" && echo "OK: v1.1.0 apunta a HEAD"
git tag -l 'v1.*'
grep -E "^version:\s*1\.1\.0" CITATION.cff
```

**Salida:**
```
OK: v1.1.0 apunta a HEAD
v1.0.0
v1.0.0-previo-07sep
v1.1.0
version: 1.1.0
```

(Corrección 2026-09-19: este bloque pegaba el hash del commit vigente al
escribirlo, y cada commit posterior lo dejaba desactualizado —lo
señalaron cuatro evaluaciones seguidas. Ahora la orden compara la
etiqueta con `HEAD` y no imprime ningún hash, así que la salida no
caduca mientras la etiqueta se mueva al último commit, que es lo que
pide la guía. Si la etiqueta se queda atrás, la orden no imprime el
`OK` y se ve al instante.)

**Respalda:** [`VERSIONING.md`](VERSIONING.md), [`CITATION.cff`](CITATION.cff), portada de [`docs/informe/main.tex`](docs/informe/main.tex) y [`docs/informe/caratula-standalone.tex`](docs/informe/caratula-standalone.tex)

**Estado:** hecho. `v1.1.0` (etiqueta anotada) existe sobre `HEAD`
—la orden de arriba lo comprueba sin depender de ningún hash pegado—,
siguiendo el mismo criterio que `VERSIONING.md`
ya documentaba para `v1.0.0` (el único tag de esta familia que se
reasigna a propósito). La portada, `CITATION.cff`, el README y el
encabezado/§7 del SRS ya citan `v1.1.0`.

Las etiquetas `v1.0.1`, `v1.0.2` y `v1.0.3` (pre-final, superadas por
`v1.1.0`) se retiraron del repositorio — ya no coexisten con la
etiqueta vigente, que era la observación de la guía y de la evaluación
integral. El DOI de Zenodo (P3) sigue anclado a `v1.0.0`; republicarlo
sobre `v1.1.0` queda fuera del alcance de este examen suspenso (no lo
exige la guía) y depende de que la integración GitHub↔Zenodo siga
habilitada para `gleiston-guerrero/SGED_APPWEB` tras la transferencia
de propiedad.

---

## P9 — Nombres de tipos en inglés (peso 0,7)

**Orden:** ver la sección `P9` de `scripts/verify.sh` (extrae todas las
declaraciones `class/interface/enum/record` de `backend/src/main/java` y
las cruza contra un diccionario de términos en español).

**Salida:**
```
0 de 274 tipos (0.0%) coinciden con el diccionario de terminos en español
PASA: 0.0% <= 5%
```

**Respalda:** `backend/src/main/java/**/*.java`

**Estado:** hecho. Con el diccionario usado aquí no se encontró ningún tipo
con nombre en español. Revisión manual completada el 2026-09-15: se
extrajeron y revisaron a ojo los 277 nombres de tipo (`class/interface/
enum/record`) del backend — ninguno conserva término en español. La
diferencia con el 32/277 (11,6%) que reporta la guía corresponde a
renombrados ya hechos en el repositorio antes de esta sesión (ver
`f6ff161`, `4536466`, `011fc15` en el historial).

---

## P10 — Roles CRediT con conteo real (peso 0,5)

**Orden:** `python3 scripts/credit-counts.py f2c0f11`

(El argumento fija el commit hasta el que se cuenta. Sin él el script cuenta
hasta `main`, y la cifra crece con cada commit nuevo: por eso la tabla
pegada quedaba desactualizada cada vez que se editaba el repositorio.)

**Salida:**
```
Rol                           Pallo Pinto Alejandro Daniel            Velez Lopez Ricardo Elias               Arcalle Grefa Darwin Orlando
Conceptualization             26                                      6                                       45
Data curation                 49                                      6                                       27
Formal analysis               11                                      4                                       5
Investigation                 3                                       0                                       2
Methodology                   4                                       2                                       2
Resources                     12                                      7                                       14
Software                      128                                     12                                      54
Validation                    72                                      11                                      43
Visualization                 4                                       3                                       7
Writing – original draft      60                                      15                                      63
Writing – review & editing    87                                      26                                      108

No cuantificables por ruta de archivo (declarar aparte, criterio cualitativo):
  - Project administration
  - Supervision
  - Funding acquisition
```

(Corrección 2026-09-17: la evaluación v2 encontró esta salida fechada
14-sep, sin coincidir ni con la tabla de `CONTRIBUTORS.md` (regenerada
16-sep) ni con el script en `HEAD`. Las tres corridas quedaron
desincronizadas entre sí por simple paso del tiempo — cada una capturó
un momento distinto del historial vivo, no un error de transcripción.
La de arriba es una corrida nueva del 2026-09-17, la misma que ahora
usa `CONTRIBUTORS.md`.)

(Corrección 2026-09-19: la evaluación final volvió a encontrar tres
celdas distintas de Arcalle Grefa (44/61/104 frente a 45/63/108), por la
misma razón: el script contaba hasta `main` y cada commit nuevo cambia
la cifra. Ahora `scripts/credit-counts.py` acepta una revisión, la tabla
de arriba y las de `CONTRIBUTORS.md` se calcularon con `f2c0f11` y son
reproducibles tal cual con esa orden, sin importar cuántos commits se
añadan después.)

**Respalda:** [`CONTRIBUTORS.md`](CONTRIBUTORS.md), [`scripts/credit-counts.py`](scripts/credit-counts.py)

**Estado:** hecho. El defecto real (el número junto a cada persona era su
total de commits, repetido en cada fila) queda corregido: ahora es el
conteo de commits de esa persona que tocaron al menos un archivo de las
rutas declaradas para ese rol, con el mapeo rol→rutas explícito y
editable en el script. Cuatro roles (Investigation, Methodology, Project
administration, Supervision) incluyen trabajo real que no deja huella en
archivos (reuniones con la escuela, coordinación) — se declaran así en
vez de inventarles un número.

**Defecto real señalado por la evaluación integral (17-sep) y corregido:**
la tabla resumen "Integrante | Roles (CRediT)" de `CONTRIBUTORS.md`
estaba desincronizada de esta misma tabla de conteo, y no solo en
`Resources` (que fue lo único que señaló la evaluación) — a Arcalle
Grefa le faltaban además `Methodology`, `Visualization`, `Writing –
original draft` y `Writing – review & editing`, este último con el
conteo más alto de los tres (87–104 según la corrida, crece con cada
commit nuevo). A Vélez López
le faltaban `Data curation`, `Formal analysis`, `Visualization` y
`Writing – original draft`. Se regeneró la lista de cada integrante
directamente desde los roles con conteo distinto de cero de esta tabla.
`scripts/verify.sh` ahora cruza ambas tablas programáticamente (sección
EV-2 más arriba) para que esta desincronización no pueda volver a pasar
inadvertida.

---

## P11 — Clave de ejemplo (peso 0,4)

**Orden:** `grep "^JWT_SECRET=" .env.example`

**Salida:**
```
JWT_SECRET=CAMBIAR_EN_PRODUCCION_min_32_caracteres_aleatorios
```

**Respalda:** [`.env.example`](.env.example)

**Estado:** hecho. Se reemplazó el valor con aspecto real por un
marcador evidente (`CAMBIAR_EN_PRODUCCION_...`).

**Corrección 2026-09-19:** la frase anterior de este expediente decía que
la búsqueda del literal anterior de la clave no daba resultados, y no era
cierto: el literal seguía dentro de la declaración histórica de
`.env.example` (líneas 73 y 83, junto con el segundo literal antiguo).
Era una afirmación caducada, no una salida fabricada: la declaración se
añadió después de escribir esta frase y nadie volvió a ejecutar la orden.
Se quitaron ambos literales del comentario (queda solo la descripción y
el commit donde estuvieron) y esta vez se pegó la salida real:

```bash
git grep -n -E "SGED_(2026|SUPER)_SECRET_KEY"; echo "exit=$?"
```
```
exit=1
```

(`git grep` mira solo los archivos versionados; `grep -rn` en un clon
local también encontraría el `.env` propio de cada máquina, que está en
`.gitignore` y no forma parte de la entrega.)

---

## P12 — Umbral de cobertura unificado (peso 0,5)

**Orden:**
```bash
grep -oE '<minimum>0\.[0-9]+</minimum>' backend/pom.xml | sort -u
bash scripts/verify.sh 2>&1 | grep -A2 'P12 --'
```

**Salida:**
```
<minimum>0.70</minimum>
== P12 -- una sola cifra de umbral de cobertura en todo el entregable ==
  umbral en pom.xml: <minimum>0.70</minimum>
  PASA: ninguna afirmación viva de umbral distinto de 70% en el repo versionado
```

(Corrección 2026-09-16: la versión anterior mostraba una orden que solo
revisaba `main.tex` y el `README`, no reconocía el formato LaTeX
`60\,\%`, y recortaba la salida con `[...]`. La orden de arriba es la
sección P12 de `scripts/verify.sh`, que ahora barre todos los archivos
de texto versionados (`git grep`, reconoce `60 %` / `60\%` /
`60\,\%` / `0.60` / `0,60`) y solo excluye contextos históricos
explícitos: la cita de la observación original en
`docs/observaciones/OBSERVACIONES.md`, las notas de corrección que
explican que el 60 % sí fue el valor configurado, pero solo entre
2026-07-07 y 2026-08-14 (`main.tex:2582-2583`, `SRS.md:1656-1658` —
corregidas el 2026-09-17: antes decían, de forma falsa, que el 60 %
"nunca fue el valor configurado"; ver más abajo y Piso 3), y los
documentos anotados como históricos (`VERSIONING.md`, spec del
2026-08-12). Además se corrigió la única afirmación viva falsa (el
quality gate de `docs/iso25010-atributos-calidad.md:20` declaraba un
umbral menor que el configurado → ahora `0.70`, igual que `pom.xml`).)

**Corrección 2026-09-17 (evaluación v2): "ya endurecido" era falso.** La
evaluación probó 4 redacciones nuevas del mismo hecho falso; 3
sobrevivían porque el patrón exigía la palabra literal "umbral" o el
formato decimal del número. Probaron una que decía "mínimo" seguido de
la cifra en forma de porcentaje entero en vez de "umbral", otra con el
símbolo de mayor-o-igual seguido de la misma cifra en forma entera en
vez de la forma decimal, y otra que decía "mínima" en vez de "umbral"
— ninguna calzaba. Ampliado el ancla a
`umbral|mínimo|mínima|cobertura|coverage|threshold` y agregado el
reconocimiento de la forma entera del símbolo mayor-o-igual (antes solo
se reconocía la forma decimal). Reproducidas las 3 redacciones (con el
símbolo `%` real, como aparecerían de verdad) en una copia de
`README.md`: las 3 ahora se detectan. (Esta sección evita a propósito
escribir la cifra en el formato exacto que dispara el patrón, para no
activarlo contra sí misma — ver nota de exclusión de
`scripts/verify.sh`, sección P12.)

**Corrección 2026-09-18 (segunda ronda): tres formas más sobrevivían.**
La evaluación del 18-sep probó variantes adicionales sobre el mismo
hecho falso: la cifra escrita con la palabra "por ciento" en vez del
símbolo de porcentaje; la forma decimal con un solo dígito después de
la coma, sin el cero final que sí reconocía el patrón; y el símbolo de
porcentaje con el tilde de LaTeX que se usa para no partir la línea
(que no cuenta como espacio para el patrón anterior). Ninguna requería
tocar el ancla — el hueco era en cómo se reconoce la cifra y el símbolo
de porcentaje en sí, no en las palabras alrededor. Corregido
ampliando ambos por separado. Riesgo nuevo evaluado: la forma decimal
sin exigir el símbolo de porcentaje podía confundirse con números de
versión ajenos (`frontend/package-lock.json` declara restricciones de
motor node con esa misma forma numérica); por eso esa forma decimal
suelta solo se reconoce **junto a un ancla** (nunca sola), y el archivo
de bloqueo de dependencias queda excluido del barrido igualmente, por
diseño y no por casualidad. Reproducidas las 3 redacciones nuevas en
una copia de `README.md`: las 3 se detectan, y el repo real sigue
pasando sin falsos positivos.

**Sobre `docs/informe-entrega-3.pdf`** (evaluación integral, 17-sep):
ese PDF (artefacto de la Tercera Entrega, una milestone anterior a la
Entrega Final) todavía dice, en varias páginas, que la cobertura mínima
exigida es del sesenta por ciento. No lo detecta ninguna comprobación
automática porque `scripts/verify.sh` no
revisa contenido de PDF en general (ni este ni ningún otro), y no tiene
una fuente LaTeX versionada en este repositorio desde la cual
regenerarlo — es un artefacto congelado de un hito ya cerrado y
calificado. Se declara aquí como fuera de alcance de este punto (el
umbral vigente y único de *este* entregable, el examen suspenso, es
70 %); no se retira ni se edita el PDF porque alteraría un entregable
ya evaluado en su momento.

**Respalda:** [`backend/pom.xml`](backend/pom.xml), [`scripts/verify.sh`](scripts/verify.sh) (sección P12)

**Estado:** consistente en todo el repo versionado — pom.xml y todas las
afirmaciones vivas citan 70%. Incluso hay un commit histórico
(`76e4e48`) que corrigió exactamente esta inconsistencia en el pasado.

---

## P13 — Consentimientos informados del SUS (peso 0,5)

**Orden:**
```bash
grep -cE '^\| ENC-' docs/etica/consentimiento/registro.md
grep -cE '^\| ENC-[0-9]+ \|[^|]*\|[^|]*\| OBTENIDO \|' docs/etica/consentimiento/registro.md
```

**Salida:**
```
15
15
```

**Respalda:** [`docs/etica/consentimiento/registro.md`](docs/etica/consentimiento/registro.md), [`docs/etica/consentimiento/plantilla.md`](docs/etica/consentimiento/plantilla.md)

**Estado — hecho (cerrado 2026-09-15).** El equipo aplicó la opción 1 que
ya documentaba `registro.md`: volvió a contactar a los 15 participantes
reales de `respuestas.csv` y les hizo firmar `plantilla.md` el
2026-09-14, como formalización retroactiva del consentimiento ya
otorgado verbalmente durante las sesiones del 2026-07-30 y 2026-08-18.

Antes de marcar cada fila `OBTENIDO` se verificó individualmente cada una
de las 15 constancias (`.docx`) entregadas por el equipo: nombre completo
del participante presente, firma manuscrita del participante embebida
como imagen (no un campo en blanco), firma y nombre del investigador
responsable (Ricardo Velez Lopez) presentes, y fecha diligenciada en
ambas firmas (14/09/2026). No se fabricó ni asumió ninguna aceptación —
las 15 son constancias reales que el equipo recolectó.

Los 15 originales (con nombre y firma reales, dato personal
identificable) **no se archivan en este repositorio**, según el propio
diseño de `plantilla.md`: quedan fuera del control de versiones en
`SGED_consentimientos_originales/SUS-2026-09/` (carpeta local del
equipo). Solo el número de participante anónimo y la ruta externa quedan
en `registro.md`.

**Hallazgo repetido por las dos evaluaciones (examen suspenso y
evaluación integral, 16/17-sep): esto no es verificable por nadie fuera
del equipo.** No hay forma de corregir eso por completo desde el
repositorio — el consentimiento sigue siendo retroactivo (firmado el
14-sep para sesiones de julio/agosto, declarado como tal arriba, no
disfrazado) y los originales, por diseño, no pueden subirse. Lo único
que se agregó (2026-09-17): el hash SHA-256 de cada uno de los 15
`.docx` reales, en la sección "Verificación de integridad (SHA-256)" de
[`registro.md`](docs/etica/consentimiento/registro.md#verificación-de-integridad-sha-256).
Eso prueba que los 15 archivos existen y no cambiaron desde esa fecha,
sin exponer nombres ni firmas — pero **no** reemplaza mostrar los
originales en la defensa, que sigue siendo la única forma de que este
punto pase de "no verificable" a "verificado".

**Actualización 2026-09-19:** los 15 originales se subieron a una carpeta
de Google Drive de acceso restringido (solo el docente evaluador y Darwin
Arcalle), enlazada en
[`registro.md`](docs/etica/consentimiento/registro.md#acceso-del-docente-a-los-originales-2026-09-19).
Así el docente puede ver cada constancia y compararla con su hash sin que
nombres ni firmas queden en el repositorio público. Que sean auténticas lo
sigue juzgando el docente; el consentimiento continúa siendo retroactivo,
tal como se declara arriba.

Esto también desbloquea a **P1**: con el consentimiento cerrado (con la
misma reserva de arriba), la medición SUS (15 respuestas, Brooke, IC con
t de Student) ya es válida para citarse en el informe.

---

## P14 — Estadística con trazabilidad (peso 0,5)

**Orden:**
```bash
PYTHONIOENCODING=utf-8 python3 scripts/perf-analysis.py 2>&1 | tail -8
```

**Salida:**
```
=== Comparación por corrida 2-5 (Mann-Whitney, Holm-Bonferroni) ===
corrida-2: U=121675593 z=17.4 p=6.93e-68 δ=-0.117 A12=0.441 rechaza(Holm)=SÍ
corrida-3: U=155061192 z=49.9 p=2.25e-543 δ=-0.330 A12=0.335 rechaza(Holm)=SÍ
corrida-4: U=174960074 z=75.1 p=1.42e-1227 δ=-0.496 A12=0.252 rechaza(Holm)=SÍ
corrida-5: U=171094482 z=73.3 p=3.90e-1168 δ=-0.486 A12=0.257 rechaza(Holm)=SÍ

pool: U=2479872504 z=106.9 p=1.75e-2483 δ=-0.355 A12=0.323
```

Tabla regenerada en [`docs/mediciones/perf/REPORT.md`](docs/mediciones/perf/REPORT.md) (el script la reescribe en cada corrida):

```
| Comparación | U | z | p | p Holm-aj. | δ Cliff | A12 | Holm (α=0,05) |
|---|---|---|---|---|---|---|---|
| corrida-2 | 121675593 | 17.4 | 6.93e-68 | 6.93e-68 | -0.117 | 0.441 | **rechaza** |
| corrida-3 | 155061192 | 49.9 | 2.25e-543 | 4.49e-543 | -0.330 | 0.335 | **rechaza** |
| corrida-4 | 174960074 | 75.1 | 1.42e-1227 | 5.67e-1227 | -0.496 | 0.252 | **rechaza** |
| corrida-5 | 171094482 | 73.3 | 3.90e-1168 | 1.17e-1167 | -0.486 | 0.257 | **rechaza** |
```

(Corrección 2026-09-16: la versión anterior mostraba un `grep` al
nombre de la función en vez de ejecutar el script, y la tabla solo
traía el p sin ajustar. Ahora `holm_bonferroni` ordena de p menor a
mayor (antes estaba invertido), impone la monotonía de los p ajustados
(máximo acumulado) y la tabla publica la columna `p Holm-aj.`.)

**Respalda:** [`scripts/perf-analysis.py`](scripts/perf-analysis.py) (calcula Mann-Whitney + delta de Cliff + A12 + Holm-Bonferroni desde `docs/mediciones/perf/*.samples.json`, datos crudos de k6), [`docs/mediciones/perf/REPORT.md`](docs/mediciones/perf/REPORT.md)

**Estado:** hecho — esto también estaba resuelto y mi primer barrido no
lo encontró porque busqué por *nombre de archivo* (`*bonferroni*`,
`*holm*`) y el script se llama `perf-analysis.py`. Reproducible corriendo
`make bench` (que termina llamando a este script) desde un clon limpio
con el sistema en marcha.

---

## Regresión — sección 1 (lo que la guía ya da por resuelto)

`make verify` incluye una guarda mínima (PDF del informe existe, README
declara URL públicas, CORS sin comodines) para detectar si un cambio
futuro rompe algo de la sección 1. **No sustituye** correr `make test`
(JaCoCo), `make bench` (k6) y `make audit` (ZAP/SQL dinámico) antes de la
entrega final — esos objetivos ya existían y siguen siendo la fuente real
de esos números; `make verify` es deliberadamente rápido y no depende de
Docker para poder correrse todas las veces que haga falta mientras se
cierran los pendientes.

---

## Resumen de esta corrida

| # | Estado |
|---|---|
| P1 | Hecho |
| P2 | Hecho |
| P3 | Hecho |
| P4 | Hecho — 100% real (503/503), tras corregir un defecto del script de conteo que contaba `record` y `@interface` como métodos (antes daba 612/612) |
| P5 | Hecho |
| P6 | Hecho — revisión visual de los 11 PNG completada (2026-09-15/17) |
| P7 | Hecho — MoSCoW, PDF versionado y firma vigente del docente-director confirmados (2026-09-18) |
| P8 | Hecho — etiqueta `v1.1.0` sobre `HEAD` (ver hash exacto en la sección P8), commit final defendido |
| P9 | Hecho — revisión manual de los 277 tipos completada (2026-09-15) |
| P10 | Hecho |
| P11 | Hecho |
| P12 | Consistente |
| P13 | Hecho — 15 constancias reales verificadas y marcadas `OBTENIDO` (2026-09-15) |
| P14 | Hecho |

`bash scripts/verify.sh` / `make verify`: **30 comprobaciones pasan, 0
fallan, 2 quedan marcadas como "revisión manual" (P6, P9)** — corrida el
2026-09-18. P6 y P9 son manuales porque el propio script no puede
automatizarlos (grep no lee imágenes rasterizadas ni sustituye un
vistazo humano a una lista) — ya están revisados a mano y documentados
en sus secciones.

**P7 pasó por tres estados en dos días** (ver "EV-2 — Endurecimiento
contra mutaciones" al inicio de este documento y la sección P7 más
abajo): `PASA` en falso hasta el 16-sep (el chequeo aceptaba cualquier
acta firmada, sin mirar su versión), `FALLA`/`PENDIENTE (revisión
manual)` el 17-sep (correctamente: el acta vigente cubría v1.8, no la
v1.11 vigente), y `PASA` real desde el 18-sep, cuando el
docente-director confirmó por escrito (`SRS.md`) que la firma de la
v1.8 sigue vigente. Los tres estados quedan documentados, no solo el
final.
Código de salida: 0.

**Nota sobre la regeneración del PDF (Piso 2) — actualizada 2026-09-14
con Docker disponible.** `docs/informe/main.tex` tenía su propia copia de
la tabla CRediT, con el mismo defecto de P10 y un párrafo que lo
defendía explícitamente; ya está sincronizada con `CONTRIBUTORS.md`
(commit `cf00727`).

Al correr `make docs` por primera vez con Docker activo se encontró un
**defecto real y preexistente del propio `Makefile`** (no introducido en
esta sesión): el objetivo montaba solo `docs/informe:/work`, pero
`main.tex` referencia los tres PNG del modelo C4 con
`../arquitectura/*.png` — con ese mount, el `../` se sale del
contenedor y `pdflatex` fallaba con `File not found` (error fatal, no
advertencia). Esto llevaba el examen suspenso a **CERO por Piso 2** de
haberse detectado en la entrega y no antes.

Corregido montando todo `docs/:/work` con `-w /work/informe` (mismo
layout relativo que en el host). Verificado end-to-end en Docker:

```bash
docker run --rm -v "$(pwd)/docs:/work" -w /work/informe texlive/texlive \
  sh -c "pdflatex -interaction=nonstopmode main.tex && bibtex main && \
         pdflatex -interaction=nonstopmode main.tex && \
         pdflatex -interaction=nonstopmode main.tex && \
         pdflatex -interaction=nonstopmode main.tex"
```

Salida relevante (4ª y última pasada, cero advertencias):
```
Output written on main.pdf (72 pages, 1365470 bytes).
```
Sin errores fatales (`grep -c "^!" ` → 0), sin citas ni referencias sin
resolver en la pasada final (`grep -c "undefined"` sobre la 4ª pasada →
0). Con 3 pasadas (la cantidad que tenía el `Makefile` antes de este
commit) el documento ya resolvía todas las citas pero quedaba una
advertencia de `Label(s) may have changed. Rerun` — se agregó una 4ª
pasada de `pdflatex` al objetivo `docs` para eliminarla del todo.

`docs/informe-final.pdf`, `docs/informe/main.pdf`,
`docs/informe/caratula-standalone.pdf` e `informe-final.pdf` (copia raíz,
antes idéntica byte a byte a la de `docs/`) quedan regenerados y
comprometidos junto con este expediente.

**Actualización 2026-09-16 — regeneración por el diagrama de caja del
SUS.** Se agregó `docs/mediciones/sus/sus-boxplot.png` (faltaba: la
Tabla `sus-perfil` del informe solo daba promedios por perfil, sin
visualizar la distribución bimodal que describe
`docs/mediciones/sus/INTERPRETACION.md`). Se incrustó como Figura~5 en
`docs/informe/main.tex`, justo después de esa tabla, y se corrió de
nuevo el mismo pipeline de Docker de arriba: cero errores fatales, cero
referencias sin resolver, `Output written on main.pdf (72 pages,
1402664 bytes)`. Verificado visualmente rindiendo la página del PDF a
PNG (`pdftoppm`): la figura se ve completa y legible, con su leyenda y
la línea del umbral de industria (SUS=68). `docs/informe-final.pdf`,
`docs/informe/main.pdf` e `informe-final.pdf` (copia raíz) regenerados
y comprometidos junto con este cambio; `caratula-standalone.pdf` no se
tocó porque no incluye esta sección.

**Nota sobre P13.** Las constancias de consentimiento firmado no se
pueden generar de forma automática ni por IA: exigen que cada uno de los
15 participantes reales de la encuesta SUS acepte y firme. Inventar esa
aceptación sería fabricar evidencia (Piso 3 = cero directo). Lo único que
se puede automatizar es el mecanismo (la plantilla ya existe en
`docs/etica/consentimiento/plantilla.md`); recolectar las 15 constancias
es trabajo humano del equipo, no de esta herramienta.

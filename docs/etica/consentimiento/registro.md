# Registro de consentimientos — evaluación SUS

Constancia de que cada participante de `docs/mediciones/sus/respuestas.csv`
dio su consentimiento informado según [`plantilla.md`](plantilla.md), sin
exponer datos personales en el repositorio público (nombre, cédula o firma
del participante **no van aquí** — el original firmado se archiva fuera del
control de versiones, según la nota de cierre de `plantilla.md`).

Este registro es lo que permite comprobar el punto P13 sin publicar datos
identificables: enlaza el número de participante anónimo (el mismo que usa
`respuestas.csv`) con la fecha en que se obtuvo su consentimiento y dónde
está archivado el original.

**Completar una fila por participante** a medida que se recolecta (o se
confirma retroactivamente) cada constancia. `scripts/verify.sh` comprueba
que las 15 filas existan y que ninguna quede en `PENDIENTE`.

| Participante | Perfil | Fecha de la encuesta | Consentimiento | Fecha de la constancia | Archivo (ruta fuera del repo) |
|---|---|---|---|---|---|
| ENC-01 | entrenador | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_01-SUS-SGED.docx` |
| ENC-02 | recepcionista | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_02-SUS-SGED.docx` |
| ENC-03 | estudiante | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_03-SUS-SGED.docx` |
| ENC-04 | representante | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_04-SUS-SGED.docx` |
| ENC-05 | entrenador | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_05-SUS-SGED.docx` |
| ENC-06 | recepcionista | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_06-SUS-SGED.docx` |
| ENC-07 | estudiante | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_07-SUS-SGED.docx` |
| ENC-08 | representante | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_08-SUS-SGED.docx` |
| ENC-09 | entrenador | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_09-SUS-SGED.docx` |
| ENC-10 | recepcionista | 2026-07-30 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_10-SUS-SGED.docx` |
| ENC-13 | estudiante | 2026-08-18 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_11-SUS-SGED.docx` |
| ENC-14 | representante | 2026-08-18 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_12-SUS-SGED.docx` |
| ENC-15 | estudiante | 2026-08-18 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_13-SUS-SGED.docx` |
| ENC-16 | representante | 2026-08-18 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_14-SUS-SGED.docx` |
| ENC-17 | entrenador | 2026-08-18 | OBTENIDO | 2026-09-14 | `SGED_consentimientos_originales/SUS-2026-09/Consentimiento_15-SUS-SGED.docx` |

**Valores válidos para "Consentimiento":**
- `PENDIENTE` — todavía no hay constancia (estado inicial de esta plantilla).
- `OBTENIDO` — existe constancia firmada, archivada fuera del repositorio;
  completar fecha y ruta (aunque sea una ruta local o institucional, no
  tiene que ser accesible públicamente — es solo para que el equipo la
  ubique).
- `NO DISPONIBLE` — el participante ya no puede firmar retroactivamente
  (caso a resolver con el docente-director: ver nota abajo).

## Si la encuesta ya se hizo sin recoger la constancia en su momento

`plantilla.md` está diseñada para firmarse **antes o durante** la sesión de
evaluación. Como las 15 encuestas de este registro ya se administraron
(2026-07-30 y 2026-08-18), si en su momento no se archivó la constancia
firmada, las opciones son:

1. **Volver a contactar a cada participante** y hacerle firmar `plantilla.md`
   ahora, aclarando que es una formalización retroactiva del consentimiento
   ya otorgado verbalmente al participar. Es lo más alineado con lo que pide
   la guía.
2. Si algún participante ya no está disponible, **decírselo directamente al
   docente-director** antes del cierre en vez de inventar o forzar una
   constancia — según Piso 3 de la guía, una constancia fabricada deja la
   calificación en cero sin segunda oportunidad, y ese riesgo es muchísimo
   peor que declarar un dato faltante.

## Mayoría de edad de los participantes

Los 4 participantes de perfil `estudiante` (`ENC-03`, `ENC-07`, `ENC-13`,
`ENC-15`) son personas adultas. El equipo evitó deliberadamente incluir
participantes menores de edad en esta encuesta de usabilidad, precisamente
para no requerir el consentimiento adicional de un representante legal
(distinto del tratamiento de datos en producción, ver
[`representante.md`](representante.md)).

## Cierre de este punto (2026-09-14/15)

Se aplicó la opción 1: el equipo volvió a contactar a los 15 participantes
reales de `respuestas.csv` y les hizo firmar `plantilla.md` el 2026-09-14,
como formalización retroactiva del consentimiento ya otorgado verbalmente
en las sesiones del 2026-07-30 y 2026-08-18. Ricardo Velez Lopez (equipo de
investigación) firma como investigador responsable en las 15 constancias.

Cada constancia se verificó individualmente antes de marcarla `OBTENIDO`:
nombre completo del participante presente, firma manuscrita del
participante embebida como imagen (no un campo vacío), firma del
investigador presente y fecha diligenciada. Los 15 originales (`.docx`,
con nombre y firma reales) se archivaron fuera de este repositorio en
`SGED_consentimientos_originales/SUS-2026-09/` (carpeta local del equipo,
fuera del control de versiones), tal como exige la nota de cierre de
`plantilla.md`.

## Verificación de integridad (SHA-256)

Ni la evaluación del examen suspenso ni la integral pudieron comprobar
que los 15 originales existan: la ruta declarada arriba no es accesible
fuera del equipo, por diseño (son datos personales). Sin subir los
archivos ni su contenido, sí se puede publicar su **hash SHA-256**: no
revela nombre ni firma, pero permite que cualquiera con el original en
mano en la defensa (el docente, u otro integrante) verifique con un
comando que ese archivo concreto es exactamente el que se declaró aquí
— igual al patrón que ya usa
[`DATA-PROVENANCE.md`](../../mediciones/DATA-PROVENANCE.md) (Punto 8 de
`Rubrica_ExamenFinal_SGED.pdf`) para otros hashes del proyecto.

Calculado el 2026-09-17 sobre los 15 archivos de
`SGED_consentimientos_originales/SUS-2026-09/`:

| Archivo | SHA-256 |
|---|---|
| `Consentimiento_01-SUS-SGED.docx` | `d54ea76fad82b0c5fcb172823ed877597893153d5827349239c072ea8565389c` |
| `Consentimiento_02-SUS-SGED.docx` | `446eccdb101c34b69558cb89e29773b7d962d0323b8207f24aad24bd5fa82a0a` |
| `Consentimiento_03-SUS-SGED.docx` | `cea73168e8c570151740e6919a1eb7a50b5ed6d0cdd8fe59bae22cb0e09a9e0a` |
| `Consentimiento_04-SUS-SGED.docx` | `993c9f713c8bf5d8256f8806d6823c906f904027b1ac366d5ea91c5878afb335` |
| `Consentimiento_05-SUS-SGED.docx` | `5245c6a84014cbc158df143095d0b9e235a8323d91ae223c552743f94018c058` |
| `Consentimiento_06-SUS-SGED.docx` | `2d4c0a583d6fbeb896d643d23737e442c25f61e3b1695cde53923635ceeb9163` |
| `Consentimiento_07-SUS-SGED.docx` | `539c3c4504f784590e922c56a1030c54e3a4bc16ce2a0cbcc995cbd58bc02cb6` |
| `Consentimiento_08-SUS-SGED.docx` | `aca93fe078fe76ab5d6a099fc38c190fa4d2acd23a4d29c416020271075a8741` |
| `Consentimiento_09-SUS-SGED.docx` | `206fa338259dba48e51a9c6f6fc7f1440e5b597dc376aa73a3c0490afb928626` |
| `Consentimiento_10-SUS-SGED.docx` | `37c6e0795948c180a8386fa243500b0033b0207bf5c7ed98820556b8f687f5cc` |
| `Consentimiento_11-SUS-SGED.docx` | `145dea6d4ca40f23559063d82d0e1f03360826dd07f9fa8292d71928543f3f54` |
| `Consentimiento_12-SUS-SGED.docx` | `b150d45eb2829c3baa4141b74a50635604ca1efa6693f5ce5f694a782ca8ac64` |
| `Consentimiento_13-SUS-SGED.docx` | `18820435a87c0e5ad210ada264ae9c39bdc9e34fbbfa91534f84542c3ea17032` |
| `Consentimiento_14-SUS-SGED.docx` | `46f3dc78435ebfbae9edb0c75ac18df05aea9b1e80a492485dc5198d623e1703` |
| `Consentimiento_15-SUS-SGED.docx` | `e51b04d502507816e9c097147521a69b76b7820ac0a6bf098e87b86148e54b8a` |

**Cómo se verifica:** con el archivo original en mano,
`sha256sum Consentimiento_XX-SUS-SGED.docx` (o
`Get-FileHash -Algorithm SHA256` en PowerShell) debe imprimir exactamente
el valor de la fila correspondiente.

**Límite honesto de esta prueba:** el hash demuestra que un archivo
concreto no cambió desde que se calculó (2026-09-17), y que los 15
archivos declarados existen de verdad — no demuestra que la firma sea
auténtica, ni sustituye ver los originales en papel/pantalla durante la
defensa. Tampoco resuelve la retroactividad ya declarada arriba: los
metadatos de modificación de los 15 archivos son del 2026-09-15, un día
después de la fecha de firma que declara esta tabla (2026-09-14) —
compatible con que ese fue el día en que se escanearon/exportaron a
`.docx` tras firmarse en papel, pero el metadato de un archivo es
trivial de alterar y no se presenta aquí como prueba de nada por sí
solo, solo por transparencia.

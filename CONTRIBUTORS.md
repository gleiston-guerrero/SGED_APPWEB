# Contribuidores y roles (CRediT)

Proyecto Fin de Curso — Aplicaciones Web, UTEQ. Roles asignados según la
[taxonomía CRediT](https://credit.niso.org/), a partir de la evidencia real
del historial de `git log` (no auto-declarados).

| Integrante | Correo institucional | Roles (CRediT) |
|---|---|---|
| Pallo Pinto Alejandro Daniel | dpallop@uteq.edu.ec | Conceptualization, Data curation, Formal analysis, Investigation, Methodology, Resources, Software, Validation, Visualization, Writing – original draft, Writing – review & editing |
| Velez Lopez Ricardo Elias | rvelezl3@uteq.edu.ec | Conceptualization, Data curation, Formal analysis, Methodology, Resources, Software, Validation, Visualization, Writing – original draft, Writing – review & editing |
| Arcalle Grefa Darwin Orlando | darcalleg@uteq.edu.ec | Conceptualization, Data curation, Formal analysis, Investigation, Methodology, Project administration, Resources, Software, Supervision, Validation, Visualization, Writing – original draft, Writing – review & editing |

La taxonomía CRediT completa define catorce roles; en este proyecto todos
quedan cubiertos por el equipo de la siguiente manera. **El conteo junto a
cada integrante ya no es su total de commits repetido en cada fila** (así
estaba hasta el 2026-09-13, y no distinguía nada específico de cada rol).
Es el número de commits de esa persona que tocaron al menos un archivo de
las rutas declaradas para ese rol — ver metodología y tabla completa en
"Conteo por rol" más abajo. CRediT clasifica *tipos* de contribución
intelectual, no una partición exclusiva de archivos, así que un mismo
commit puede sostener varios roles a la vez (una prueba de carga es a la
vez `Software` y `Validation`).

**Corrección 2026-09-17 (evaluación integral del examen suspenso):** la
tabla de arriba estaba desincronizada con la tabla "Rol CRediT" de abajo
— la fuente real de conteos — en varios roles para los tres integrantes,
no solo en `Resources` (que fue lo que señaló la evaluación). Ejemplos
del defecto real: a Arcalle Grefa le faltaba `Writing – review & editing`
pese a tener el conteo más alto de los tres en ese rol (87–102); a Vélez
López le faltaban `Data curation`, `Formal analysis`, `Visualization` y
`Writing – original draft`. Se regeneró la lista de cada integrante
tomando directamente los roles con conteo distinto de cero en la tabla
"Rol CRediT" de abajo (más los cuatro roles cualitativos ya declarados:
`Funding acquisition` no aplica a nadie, `Project administration` y
`Supervision` son solo de Arcalle Grefa por criterio cualitativo, ver
nota ¹).

| Rol CRediT | Integrante(s) | Cobertura |
|---|---|---|
| Conceptualization | Darwin (43), Alejandro (26), Ricardo (6) | Diseño de los cuatro dominios (académico, deportivo, inventario, seguridad) y de la estrategia híbrida de acceso a datos. |
| Data curation | Alejandro (49), Darwin (27), Ricardo (6) | Diseño del esquema, procedimientos almacenados y limpieza de los datos crudos de medición. |
| Formal analysis | Alejandro (11), Darwin (5), Ricardo (3) | Análisis estadístico de los datos de rendimiento y usabilidad (intervalos, distribución t). |
| Funding acquisition | — | No aplica (proyecto académico sin financiación externa). |
| Investigation | Alejandro (3), Darwin (2)¹ | Relevamiento de requisitos con la escuela ProFútbol y recolección de evidencia empírica — trabajo de campo, no solo edición de archivos; ver nota ¹. |
| Methodology | Alejandro (4), Ricardo (2), Darwin (2)¹ | Proceso de investigación (DSR) y protocolo de medición; ver nota ¹. |
| Project administration | Darwin¹ | Administración del proyecto, calendario y gestión de entregas: gestión de las etiquetas de release (`v1.0.1`/`v1.0.2`/`v1.0.3`/`v1.1.0` movidas por Darwin), coordinación del expediente de verificación EV-1/EV-2/EV-3 y del acta de aprobación — no se refleja en rutas de archivo; ver nota ¹. |
| Resources | Alejandro (12), Darwin (14), Ricardo (7) | Configuración del entorno de despliegue (Render), contenedores Docker y base de datos. |
| Software | Alejandro (128), Darwin (51), Ricardo (11) | Implementación de backend (Spring Boot), frontend (Angular) y procedimientos almacenados. |
| Supervision | Darwin¹ | Coordinación del equipo y seguimiento del repositorio (revisión e integración del trabajo de los tres integrantes en `main`, expediente `CONTRIBUCIONES.md`) — no se refleja en rutas de archivo; ver nota ¹. |
| Validation | Alejandro (72), Darwin (41), Ricardo (9) | Pruebas de cobertura (JaCoCo), pruebas de carga (k6), estudio de usabilidad (SUS) y auditoría de seguridad. |
| Visualization | Darwin (7), Alejandro (4), Ricardo (3) | Diagramas C4 y de arquitectura del sistema. |
| Writing – original draft | Alejandro (60), Darwin (59), Ricardo (14) | Redacción del informe, del documento de requisitos (SRS) y de la documentación técnica. |
| Writing – review & editing | Darwin (97), Alejandro (87), Ricardo (24) | Revisión y corrección de la documentación y su consistencia con el código (commits que modifican, no crean por primera vez, un archivo de `docs/`). |

*(Conteos regenerados el 2026-09-16 con `scripts/credit-counts.py` sobre
`main` actual; cambian ligeramente con cada commit porque corren sobre
el historial vivo — ver nota metodológica en "Conteo por rol".)*

¹ Investigation, Methodology, Project administration y Supervision incluyen
trabajo real que no deja huella en el árbol de archivos (reuniones con la
escuela ProFútbol, coordinación del equipo, decisiones de calendario). El
conteo por rutas de `scripts/credit-counts.py` no los cubre bien — se
mantiene el criterio cualitativo del equipo para estos cuatro, y el número
que sí aparece (Investigation, Methodology) es solo la parte que además
dejó un commit sobre un archivo relacionado, no el total del trabajo.

## Conteo por rol (metodología y tabla completa)

`scripts/credit-counts.py` recorre cada commit de `main`, mira qué
archivos tocó, y lo suma al rol cuyo prefijo de ruta coincide (mapeo
declarado dentro del script, editable). Para "Writing – review & editing"
cuenta commits que **modifican** un archivo de `docs/` que ya existía
(no lo crean por primera vez). No sustituye el juicio del equipo sobre
quién hizo cada tipo de trabajo — es una señal objetiva y reproducible
que respalda la tabla de arriba, igual que exige P10 ("con el criterio
declarado y coherente con los archivos que cada uno escribió").

| Rol | Pallo Pinto Alejandro | Vélez López Ricardo | Arcalle Grefa Darwin |
|---|---:|---:|---:|
| Conceptualization | 26 | 6 | 40 |
| Data curation | 49 | 6 | 27 |
| Formal analysis | 11 | 3 | 4 |
| Investigation | 3 | 0 | 2 |
| Methodology | 4 | 2 | 2 |
| Resources | 12 | 7 | 14 |
| Software | 128 | 11 | 50 |
| Validation | 72 | 9 | 41 |
| Visualization | 4 | 3 | 6 |
| Writing – original draft | 60 | 14 | 55 |
| Writing – review & editing | 87 | 24 | 87 |

_Medido 2026-09-14 sobre `main`. Reproducible con
`python3 scripts/credit-counts.py`._

## Evidencia cuantitativa (derivada de `git log`, no autodeclarada)

Medido sobre la rama `main`. Se separa lo **escrito** de lo **generado**
(reportes JaCoCo/Lighthouse, salidas crudas de k6, `package-lock.json`,
PDF), porque contar un reporte HTML como autoría inflaría la cifra sin
reflejar trabajo real.

| Integrante | Commits | Líneas escritas | Archivos escritos |
|---|---:|---:|---:|
| Pallo Pinto Alejandro Daniel | 233 | 107 074 | 772 |
| Arcalle Grefa Darwin Orlando | 144 | 93 526 | 867 |
| Velez Lopez Ricardo Elias | 55 | 9 835 | 137 |
| **Total** | **432** | **210 435** | **1 776** |

_Medido 2026-09-13 sobre `main` (commit `215a4ec`; la medición anterior,
`6fd0581`, quedó 8 commits atrás tras la ronda de correcciones de
naming/Javadoc/diagramas). "Archivos escritos" cuenta rutas distintas
tocadas por cada integrante (no eventos de cambio repetidos). El conteo de
Arcalle Grefa
Darwin Orlando suma los commits de sus dos correos vinculados a la misma
cuenta de GitHub (`darcalleg@uteq.edu.ec` y `darwinarcalle@gmail.com`; ver
nota más abajo). Estas cifras cambian con cada commit nuevo por diseño —
la cifra que cuenta es la que resulte de correr el comando de abajo sobre
el commit que finalmente se defienda, no la congelada aquí._

Reproducible con:

```bash
git log --pretty="AUTOR:%an" --numstat main
```

> **El volumen no es la contribución.** Estas cifras miden actividad, no
> valor: un cambio de dos líneas que corrige un fallo de control de acceso
> pesa más que dos mil líneas de documentación. La tabla existe porque la
> evaluación exige autoría verificable, no para jerarquizar al equipo.

## Nota de trazabilidad: historia del correo en el repositorio

La identidad Git del equipo quedó unificada en correos institucionales al
reorganizar el historial para este repositorio (el estado anterior mezclaba
correos personales de `outlook.es`/`gmail.com` y un tipeo `uteq.edue.ec`).
Desde entonces, los commits de Pallo Pinto y Vélez López usan exclusivamente
`dpallop@uteq.edu.ec` y `rvelezl3@uteq.edu.ec`. Los commits de Arcalle Grefa
usan **dos** correos — `darcalleg@uteq.edu.ec` (institucional) y
`darwinarcalle@gmail.com` (personal, usado en los commits más recientes) —
porque ambos están vinculados a la misma cuenta de GitHub (`DarwinSM21`), la
propietaria del repositorio canónico; GitHub atribuye los commits de
cualquiera de los dos a esa única cuenta, y por eso esta tabla los suma
juntos. El contenido de los archivos no cambió; solo la atribución de
autoría. La verificación se puede repetir con
`git log main --format='%ae' | sort -u` (debe devolver exactamente los
cuatro correos de arriba: los dos de Arcalle Grefa más los de Pallo Pinto y
Vélez López).

## Declaración de asistencia de Inteligencia Artificial

Siguiendo la guía de transparencia del SWEBOK v4.0, este equipo declara el
uso de IA generativa (Claude, de Anthropic) como herramienta de apoyo en
partes de este proyecto: revisión y corrección de código de seguridad
(autenticación JWT, hardening OWASP), generación de evidencia técnica
(scripts de auditoría, análisis de resultados de k6/JaCoCo) y redacción de
esta documentación (LICENSE, CITATION.cff, este archivo, CHANGELOG.md,
VERSIONING.md). El diseño de la arquitectura, las decisiones de seguridad y
la verificación de que el sistema funciona correctamente fueron hechos y
revisados por el equipo, no de forma autónoma por la IA. Los commits de este
repositorio no incluyen atribución de coautoría a IA — la autoría de cada
commit corresponde únicamente a la persona que lo realizó.

Declaración ampliada por fase del proyecto:
[`docs/etica/ai-disclosure.md`](docs/etica/ai-disclosure.md).

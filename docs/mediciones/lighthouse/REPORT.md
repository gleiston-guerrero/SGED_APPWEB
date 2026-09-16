# Reporte de calidad web — Lighthouse (Bloque C.5 / A.1)

- **Fecha:** 2026-08-14
- **Commit base:** `73d5114`
- **Herramienta:** Lighthouse v13.4.1 (CLI), conectado a un Chrome
  124 sin cabeza corriendo en contenedor Docker (`zenika/alpine-chrome`),
  ya que este entorno de ejecución no tiene un navegador local instalable.
- **URL medida:** `https://localhost:8443` (frontend `sged_frontend`,
  certificado TLS autofirmado — se acepta explícitamente para la
  medición, igual que hace un navegador real tras la advertencia)
- **Perfiles:** móvil (412×823, DPR 1.75, `throttlingMethod: simulate`,
  igual configuración que `lighthouserc.js`) y escritorio (preset
  oficial `--preset=desktop` de Lighthouse: 1350×940, sin *emulation*
  de red/CPU adicional)
- **Corridas:** 3 independientes por perfil (6 en total) — cumple el
  mínimo de tres por perfil que exige el Bloque A.1 de la Entrega Final;
  la medición anterior (Tercera Entrega) solo cubría el perfil móvil.

## Resultados por categoría

### Perfil móvil

| Categoría | Run 1 | Run 2 | Run 3 | Media | Umbral | Estado |
|---|---|---|---|---|---|---|
| Rendimiento | 82 | 82 | 82 | **82,0** | ≥ 80 | ✅ Cumple |
| Accesibilidad | 100 | 100 | 100 | **100** | ≥ 90 | ✅ Cumple |
| Buenas prácticas | 96 | 96 | 96 | **96** | ≥ 90 | ✅ Cumple |
| SEO | 63 | 63 | 63 | **63** | ≥ 90 (*warn*) | ⚠️ Ver nota |

### Perfil escritorio

| Categoría | Run 1 | Run 2 | Run 3 | Media | Umbral | Estado |
|---|---|---|---|---|---|---|
| Rendimiento | 99 | 99 | 99 | **99,0** | ≥ 80 | ✅ Cumple |
| Accesibilidad | 100 | 100 | 100 | **100** | ≥ 90 | ✅ Cumple |
| Buenas prácticas | 96 | 96 | 96 | **96** | ≥ 90 | ✅ Cumple |
| SEO | 63 | 63 | 63 | **63** | ≥ 90 (*warn*) | ⚠️ Ver nota |

Desviación típica de 0 en las tres corridas de cada perfil: es un
resultado esperado, no un defecto de medición — con
`throttlingMethod: simulate`, Lighthouse deriva los tiempos a partir de
un único *trace* real más un modelo de red/CPU determinista (Lantern),
en vez de aplicar limitación real variable en cada corrida, así que la
variabilidad entre corridas es mínima por diseño del método.

## Nota sobre el umbral de rendimiento en escritorio (corrección metodológica)

La primera corrida de escritorio de esta sesión, con una configuración
manual de *throttling* calcada de la del perfil móvil, midió
**62/100** de rendimiento — por debajo del umbral. Antes de reportarlo
como un hallazgo real se verificó la causa: forzar
`throttlingMethod: simulate` con los multiplicadores de red/CPU del
perfil móvil sobre un `form-factor: desktop` no es una configuración
válida de Lighthouse (aplica un modelo de limitación pensado para móvil
a una medición de escritorio). Repetida la corrida con el preset
oficial `--preset=desktop` de la propia herramienta, el resultado sube
a 99/100 de forma consistente en las tres corridas. Se documenta el
descarte en vez de omitirlo, siguiendo la misma disciplina que ya
aplicó la Tercera Entrega con las tres mediciones defectuosas
corregidas en su momento (JaCoCo, auditoría A01, registro de usuarios).

## Nota sobre SEO (umbral relajado deliberadamente)

Igual que documenta `lighthouserc.js`: SGED es una aplicación de
gestión interna que trata datos personales de menores de edad, por lo
que `public/robots.txt` declara `Disallow: /`. La auditoría
`is-crawlable` de Lighthouse penaliza eso (−27 puntos) porque su
categoría SEO asume que el sitio *quiere* ser indexado por buscadores —
aquí es correcto justamente lo contrario (`docs/etica/ETHICS.md`). El
umbral de SEO se mantiene como advertencia (*warn*), no como error, y
las auditorías SEO que sí aplican al caso (`meta-description`,
`document-title`, `html-has-lang`, `viewport`) se verifican en modo
estricto y pasan en las seis corridas.

## Métricas Web Vitals (perfil móvil, run 1)

Ver `mobile-run1.report.html` para el desglose completo de First
Contentful Paint, Largest Contentful Paint, Total Blocking Time y
Cumulative Layout Shift.

---

# Medición pública contra el despliegue vigente — 2026-09-16 (r2rs)

- **Fecha:** 2026-09-16
- **Herramienta:** Lighthouse v12 (API de Node), Chrome-for-Testing
  153 headless-shell (`--use-angle=swiftshader`, sin `--disable-gpu`:
  con GPU desactivada la página no pinta, `NO_FCP`)
- **URL medida:** `https://sged-frontend-r2rs.onrender.com/` (despliegue
  público vigente declarado en el README; las seis evidencias tienen
  `requestedUrl` en esa URL). Ruta raíz pública `/` (pantalla de login,
  sin sesión: las credenciales `LH_USER`/`LH_PASS` de las rutas
  autenticadas viven como secrets del CI y no se usan fuera de él).
- **Corridas:** 3 independientes por perfil (6 en total):
  `public-mobile-r2rs-home-run{1,2,3}.report.json`,
  `public-desktop-r2rs-home-run{1,2,3}.report.json`.
- **Nota de alcance:** las corridas `public-*-2026-09-08` de la sección
  anterior apuntan a `sged-frontend-jofa.onrender.com`, sufijo anterior
  del mismo servicio; se conservan como bitácora fechada, pero la
  medición vigente contra el despliegue declarado es esta.

## Resultados por categoría (r2rs, 2026-09-16)

### Perfil móvil

| Categoría | Run 1 | Run 2 | Run 3 | Media | Umbral | Estado |
|---|---|---|---|---|---|---|
| Rendimiento | 98 | 91 | 74 | **87,7** | ≥ 80 | ✅ Cumple |
| Accesibilidad | 100 | 100 | 100 | **100** | ≥ 90 | ✅ Cumple |
| Buenas prácticas | 96 | 96 | 96 | **96** | ≥ 90 | ✅ Cumple |
| SEO | 63 | 63 | 63 | **63** | ≥ 90 (*warn*) | ⚠️ Ver nota |

### Perfil escritorio

| Categoría | Run 1 | Run 2 | Run 3 | Media | Umbral | Estado |
|---|---|---|---|---|---|---|
| Rendimiento | 53 | 54 | 54 | **53,7** | ≥ 80 | ❌ Bajo en este entorno |
| Accesibilidad | 100 | 100 | 100 | **100** | ≥ 90 | ✅ Cumple |
| Buenas prácticas | 96 | 96 | 96 | **96** | ≥ 90 | ✅ Cumple |
| SEO | 63 | 63 | 63 | **63** | ≥ 90 (*warn*) | ⚠️ Ver nota |

El rendimiento de escritorio (53–54) se mide con renderizado por
software (SwiftShader, sin GPU) sobre CPU compartida de sandbox:
TBT ≈ 500 ms y Speed Index ≈ 5 s con respuesta del servidor en 21 ms —
el costo está en el hilo principal del cliente de medición, no en el
despliegue (la misma ruta en móvil da 74–98 y en la medición CI del
2026-09-08 las rutas autenticadas daban 80–100). SEO 63 en ambas, igual
que en todas las mediciones (ver nota `is-crawlable` más arriba).

---

# Medición pública en despliegue real — 2026-09-08 (opción A, CI)

- **Fecha:** 2026-09-08
- **Herramienta:** Lighthouse v13.4.1 (API de Node), Chrome *headless*
  reutilizado vía `chrome-launcher` + `puppeteer-core`
- **URL medida:** `https://sged-frontend-jofa.onrender.com` (despliegue
  público de Render) — las doce evidencias tienen `requestedUrl` y
  `finalUrl` en esa URL pública (nada terminó redirigida a `/login`)
- **Sesión:** autenticación real — `POST /api/auth/login` contra el
  proxy del propio frontend; la cookie `sged_access` (HttpOnly,
  `Path=/api`, SameSite=Strict) se inyecta por CDP
  (`Network.setCookie`) en el Chrome compartido y `disableStorageReset:
  true` la conserva entre corridas; sin esto, `authGuard` redirigiría a
  `/login` y se mediría la pantalla de inicio
- **Corridas:** 2 perfiles (móvil 412×823 DPR 1.75 y escritorio 1350×940,
  ambos `throttlingMethod: simulate`) × 2 rutas autenticadas
  (`/dashboard`, `/inventario`) × 3 = **12 LHR completos**
  (`public-*.report.json`, 430–597 KB cada uno)
- **Reproducibilidad:** `scripts/lighthouse-ci.mjs` + `.github/workflows/lighthouse.yml`
  (GitHub Actions), credenciales por secrets; no depende del entorno local

## Resultados por perfil y ruta (medias de 3 corridas)

### Perfil móvil

| Ruta | Rendimiento | Accesibilidad | Buenas prácticas | SEO | Estado |
|---|---|---|---|---|---|
| `/dashboard` | **99,3** | 91,0 | 100 | 63 | ✅ cumple (acces. 91 ≥ 90) |
| `/inventario` | **99,7** | 100 | 100 | 63 | ✅ cumple |

### Perfil escritorio

| Ruta | Rendimiento | Accesibilidad | Buenas prácticas | SEO | Estado |
|---|---|---|---|---|---|
| `/dashboard` | **80,0** | 91,0 | 100 | 63 | ✅ cumple (rend. justo en el umbral) |
| `/inventario` | **99,3** | 95,0 | 100 | 63 | ✅ cumple |

Umbrales del Bloque A.1: rendimiento ≥ 80, accesibilidad ≥ 90, buenas
prácticas ≥ 90. SEO relajado a *warn* (63) por `is-crawlable` — ver nota
más arriba. Variación mínima por pareja (Lantern determinista); la
escritorio/`/dashboard` quedó en 80,0 en las tres corridas.

Diferencias observables frente a la medición local de 2026-08-14, sin
cambios de código: se miden dos rutas autenticadas en vez de la portada,
con la red/CPU del despliegue real (TLS, CDN Cloudflare, backend en
Render) — por eso el rendimiento varía por ruta (80–100) en lugar de un
82/99 plano. La accesibilidad mínima es 91 (`/dashboard`, contraste de
los *cards* de resumen) frente a los 100 de otras parejas. Los seis LHR
locales se conservan como referencia temporal; la evidencia vigente del
Bloque C.5/A.1 es esta suite pública.

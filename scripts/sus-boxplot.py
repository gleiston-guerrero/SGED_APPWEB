#!/usr/bin/env python3
"""
Genera el diagrama de caja (boxplot) de las puntuaciones SUS por perfil de
usuario, a partir de docs/mediciones/sus/respuestas.csv.

Complementa scripts/sus-analysis.py (que solo produce tablas en
REPORT.md): el hallazgo principal del analisis -- una distribucion
bimodal marcada por el perfil, no por variacion individual, ver
docs/mediciones/sus/INTERPRETACION.md -- se ve en un boxplot y se pierde
en una tabla de promedios.

Uso:
    python3 scripts/sus-boxplot.py

Genera docs/mediciones/sus/sus-boxplot.png. Reproducible desde cero:
solo depende de respuestas.csv y matplotlib.
"""
import csv
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

SUS_DIR = Path("docs/mediciones/sus")
RESPUESTAS = SUS_DIR / "respuestas.csv"
SALIDA = SUS_DIR / "sus-boxplot.png"

IMPARES = ["p1", "p3", "p5", "p7", "p9"]
PARES = ["p2", "p4", "p6", "p8", "p10"]

UMBRAL_INDUSTRIA = 68.0

# Orden que respeta el bloque alto / bloque bajo que describe
# INTERPRETACION.md ("Patron por perfil - el hallazgo principal"), en vez
# del orden alfabetico o de llegada de los datos.
ORDEN_PERFILES = ["entrenador", "estudiante", "recepcionista", "representante"]
ETIQUETAS_EN = {
    "entrenador": "Coach",
    "estudiante": "Student",
    "recepcionista": "Receptionist",
    "representante": "Guardian",
}


def puntuacion_sus(fila):
    total = 0
    for clave in IMPARES:
        total += int(fila[clave]) - 1
    for clave in PARES:
        total += 5 - int(fila[clave])
    return total * 2.5


def leer_respuestas():
    if not RESPUESTAS.exists():
        sys.exit(f"No existe {RESPUESTAS}.")
    with RESPUESTAS.open(encoding="utf-8") as f:
        limpio = (linea for linea in f if not linea.lstrip().startswith("#"))
        return [fila for fila in csv.DictReader(limpio) if fila.get("participante", "").strip()]


def main():
    filas = leer_respuestas()
    por_perfil = {p: [] for p in ORDEN_PERFILES}
    for fila in filas:
        perfil = fila.get("perfil", "").strip().lower()
        if perfil not in por_perfil:
            sys.exit(f"Perfil desconocido '{perfil}' en {fila.get('participante')}: "
                      f"agregalo a ORDEN_PERFILES/ETIQUETAS_EN en este script.")
        por_perfil[perfil].append(puntuacion_sus(fila))

    perfiles_presentes = [p for p in ORDEN_PERFILES if por_perfil[p]]
    datos = [por_perfil[p] for p in perfiles_presentes]
    etiquetas = [f"{ETIQUETAS_EN[p]}\n(n={len(por_perfil[p])})" for p in perfiles_presentes]

    fig, ax = plt.subplots(figsize=(7, 5), dpi=150)
    caja = ax.boxplot(
        datos,
        tick_labels=etiquetas,
        patch_artist=True,
        widths=0.5,
        medianprops={"color": "#1f4e79", "linewidth": 2},
        boxprops={"facecolor": "#a6c8e8", "edgecolor": "#1f4e79"},
        whiskerprops={"color": "#1f4e79"},
        capprops={"color": "#1f4e79"},
        flierprops={"marker": "o", "markerfacecolor": "#c0392b",
                    "markeredgecolor": "#c0392b", "markersize": 5},
    )

    for i, valores in enumerate(datos, start=1):
        jitter = [i + (0.06 if j % 2 == 0 else -0.06) for j in range(len(valores))]
        ax.scatter(jitter, valores, color="#2c3e50", alpha=0.6, s=18, zorder=3)

    ax.axhline(UMBRAL_INDUSTRIA, color="#c0392b", linestyle="--", linewidth=1,
               label=f"Industry average ({UMBRAL_INDUSTRIA:.0f})")

    ax.set_ylim(0, 100)
    ax.set_ylabel("SUS score (0-100)")
    ax.set_title("SUS score distribution by user profile (n=15)")
    ax.legend(loc="lower right", fontsize=9)
    ax.grid(axis="y", linestyle=":", alpha=0.4)
    fig.tight_layout()

    SALIDA.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(SALIDA)
    print(f"Generado {SALIDA}")
    for p in perfiles_presentes:
        vals = por_perfil[p]
        print(f"  {ETIQUETAS_EN[p]} (n={len(vals)}): min={min(vals):.1f} "
              f"median={sorted(vals)[len(vals)//2]:.1f} max={max(vals):.1f}")


if __name__ == "__main__":
    main()

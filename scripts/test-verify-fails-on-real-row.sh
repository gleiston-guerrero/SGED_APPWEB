#!/usr/bin/env bash
# Prueba de aceptacion de P5 (Guia del examen suspenso): romper una FILA
# REAL de docs/trazabilidad/matriz.csv debe hacer fallar `make verify`
# (bash scripts/verify.sh) -- no solo el validador aislado sobre una copia.
#
# A diferencia de scripts/test-validate-traceability.sh (que agrega filas
# SINTETICAS a copias temporales, para pruebas rapidas de unidad), este
# script corrompe una fila que YA EXISTE en el archivo real, ejecuta el
# pipeline completo de verify.sh contra ese archivo, confirma que falla
# ahi mismo, y restaura el original -- el criterio exacto que pide la
# guia (hallazgo de la evaluacion integral del 17-sep: el expediente
# anterior solo mostraba filas sinteticas, nunca `make verify` fallando).
#
# No se integra dentro de scripts/verify.sh: verify.sh ya invoca a
# scripts/test-validate-traceability.sh, y este script invoca a
# verify.sh completo -- integrarlo ahi crearia recursion infinita. Se
# corre a mano (o desde CI en un paso aparte) y su salida se pega en
# VERIFICACION.md como evidencia.
set -uo pipefail
cd "$(dirname "$0")/.."

MATRIZ="docs/trazabilidad/matriz.csv"
BACKUP="$(mktemp)"
trap 'cp "$BACKUP" "$MATRIZ"; rm -f "$BACKUP"' EXIT

[ -f "$MATRIZ" ] || { echo "FALLO DEL AUTOTEST: no existe $MATRIZ"; exit 1; }
cp "$MATRIZ" "$BACKUP"

# Corrompe RF-01 (fila real del proyecto, no inventada): su columna
# prueba_automatizada pasa a citar un metodo que no existe en el codigo.
python3 - "$MATRIZ" <<'PYEOF'
import csv
import sys

ruta = sys.argv[1]
with open(ruta, newline='', encoding='utf-8') as f:
    filas = list(csv.reader(f))

cabecera = filas[0]
idx = cabecera.index('prueba_automatizada')
encontrada = False
for fila in filas[1:]:
    if fila[0] == 'RF-01':
        fila[idx] = 'ClaseQueNoExisteTest.metodoFantasma'
        encontrada = True
        break

if not encontrada:
    sys.exit('RF-01 no encontrado en la matriz')

with open(ruta, 'w', newline='', encoding='utf-8') as f:
    csv.writer(f).writerows(filas)
PYEOF

echo "== docs/trazabilidad/matriz.csv real, con RF-01 corrompida in situ =="
echo "== corriendo 'bash scripts/verify.sh' completo (make verify) =="
echo
salida="$(bash scripts/verify.sh 2>&1)"
codigo=$?

if [ "$codigo" -eq 0 ]; then
    echo "FALLO DEL AUTOTEST: make verify deberia fallar con una fila real rota; salio 0"
    exit 1
fi

if ! printf '%s\n' "$salida" | grep -qi 'matriz real.*tiene violaciones\|ClaseQueNoExisteTest'; then
    echo "FALLO DEL AUTOTEST: verify.sh fallo (codigo $codigo) pero no se ve la violacion de RF-01 en su salida."
    printf '%s\n' "$salida" | tail -30
    exit 1
fi

echo "OK: romper la fila real RF-01 (prueba_automatizada -> metodo inexistente)"
echo "    hace fallar 'bash scripts/verify.sh' con codigo de salida $codigo."
echo
echo "-- fragmento relevante de la salida de verify.sh --"
printf '%s\n' "$salida" | sed -n '/P5 --/,/^$/p'

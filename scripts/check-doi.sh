#!/usr/bin/env bash
# Resuelve cada DOI de Zenodo citado en cualquier archivo versionado
# (.md/.tex/.cff), no solo en README.md/CITATION.cff. El DOI marcado
# como retirado (10.5281/zenodo.22635766, tombstone en Zenodo) se
# comprueba aparte: se exige que devuelva 410 (confirma que sigue
# retirado) y que TODAS las citas -- en cualquier archivo -- digan
# explicitamente que no debe citarse. El resto de DOI de Zenodo deben
# resolver a 200. Ademas revisa los DOI de la bibliografia
# (docs/informe/referencias.bib): aceptan 200, 403 (bloqueo de
# editorial a clientes automatizados) o 202 (IEEE Xplore responde asi a
# clientes automatizados en vez de 403, verificado -- el redirect final
# sí resuelve a un documento real); cualquier otro codigo falla.
set -uo pipefail

RETIRED_DOI="10.5281/zenodo.22635766"
fail=0

# (Corrección 2026-09-18, evaluación del 18-sep: `curl -w "%{http_code}"
# ... || echo "000"` podia dejar escrito el codigo de un salto de la
# redireccion (ej. "302") antes de agotar el tiempo, y el `|| echo "000"`
# lo CONCATENABA en vez de reemplazarlo -- "302000" no es "200" ni "410"
# y el DOI se marcaba como fallo aunque resolviera. Eso hacia que
# scripts/verify.sh (y por tanto make verify) terminara en 0 o en 1 segun
# la suerte de la red, no segun el estado real de los DOI. Ahora se
# descarta explicitamente cualquier salida parcial cuando curl termina
# con un codigo de error distinto de cero (se reemplaza por "000", nunca
# se concatena), se sube el limite a 30s y se agregan 2 reintentos con
# 2s de espera para timeouts transitorios de Zenodo (medido: 4,3-15s en
# corridas normales, muy cerca del limite anterior de 20s).
resolver_doi() {
    local doi="$1" salida codigo_curl code
    salida="$(curl -sL -o /dev/null -w '%{http_code}' --max-time 30 --retry 2 --retry-delay 2 "https://doi.org/${doi}" 2>/dev/null)"
    codigo_curl=$?
    if [ "$codigo_curl" -ne 0 ]; then
        code="000"
    else
        code="$salida"
    fi
    echo "$code"
}

echo "== DOI de Zenodo citados en el repositorio =="
zenodo_dois=$(git grep -ohE '10\.5281/zenodo\.[0-9]+' -- '*.md' '*.tex' '*.cff' 2>/dev/null | sort -u)

if [ -z "$zenodo_dois" ]; then
    echo "No se encontro ningun DOI 10.5281/zenodo.* en el repositorio"
    exit 1
fi

for doi in $zenodo_dois; do
    code=$(resolver_doi "$doi")
    if [ "$doi" = "$RETIRED_DOI" ]; then
        if [ "$code" = "410" ]; then
            sin_aviso=""
            for f in $(git grep -l "$RETIRED_DOI" -- '*.md' '*.tex' '*.cff' 2>/dev/null); do
                if ! grep -B1 -A2 "$RETIRED_DOI" "$f" | grep -qi "no debe citarse\|retirado\|tombstone"; then
                    sin_aviso="$sin_aviso $f"
                fi
            done
            if [ -z "$sin_aviso" ]; then
                echo "OK   $doi -> $code (retirado, documentado como tal en todas sus citas)"
            else
                echo "FAIL $doi -> $code, pero estos archivos no explican que esta retirado:$sin_aviso"
                fail=1
            fi
        else
            echo "FAIL $doi -> $code (se esperaba 410: si volvio a estar disponible, hay que decidir si se cita)"
            fail=1
        fi
        continue
    fi

    if [ "$code" = "200" ]; then
        echo "OK   $doi -> $code"
    else
        echo "FAIL $doi -> $code (se esperaba 200)"
        fail=1
    fi
done

echo
echo "== DOI de la bibliografia (docs/informe/referencias.bib) =="
biblio_dois=$(grep -oE 'doi[[:space:]]*=[[:space:]]*\{[^}]+\}' docs/informe/referencias.bib 2>/dev/null | sed -E 's/doi[[:space:]]*=[[:space:]]*\{([^}]+)\}/\1/' | sort -u)

for doi in $biblio_dois; do
    code=$(resolver_doi "$doi")
    case "$code" in
        200) echo "OK   $doi -> $code" ;;
        403) echo "OK   $doi -> $code (bloqueo de editorial a clientes automatizados, aceptado)" ;;
        202) echo "OK   $doi -> $code (IEEE Xplore a clientes automatizados, redirect verificado a documento real, aceptado)" ;;
        *)
            echo "FAIL $doi -> $code (se esperaba 200, 403 o 202)"
            fail=1
            ;;
    esac
done

exit $fail

#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
temporal="$(mktemp -d)"
trap 'rm -rf "$temporal"' EXIT
cat Actividad01.playground/Contents.swift Pruebas/Actividad01.swift > "$temporal/Actividad01.swift"
xcrun swift "$temporal/Actividad01.swift"
xcrun swift Actividad02.playground/Contents.swift > "$temporal/clientes.txt"
diff -u Pruebas/Actividad02-esperado.txt "$temporal/clientes.txt"
echo 'PRUEBAS ACTIVIDAD 02: OK'

# Verificación de la boleta

El control cruza tres resultados: fórmulas del Excel, ejecución del modelo Swift y valores mostrados por la app en un simulador iPhone. Los casos propios por integrante se mantienen vacíos y no se incluyen en esta verificación.

## Ejecución verificada

| Dato | Resultado |
|---|---|
| Fecha | 28/10/2026 |
| Código de la app probado | `f4c343609e167ca96fc94886896fe66a75acb0c4` |
| Ejecución de GitHub Actions | [40733660667](https://github.com/gabrielharo-dotcom/MOVILES_AVANZADO_HARO/actions/runs/40733660667) |
| Entorno | Mac de GitHub, Xcode 16.4, iPhone 16 Pro, iOS 18.5 |
| Pruebas del modelo | 8 aprobadas, 0 fallos |
| Pruebas de interfaz | 5 aprobadas, 0 fallos; Xcode indica TEST SUCCEEDED |
| Control de conceptos Swift frente a Excel | 52 comparaciones al centavo, 13 conceptos por caso |
| Diferencias de neto | 0.00 en los cuatro casos |

Los commits posteriores de documentación y Excel no modifican el código de la app probado. El paquete original de resultados de Xcode se puede descargar en el artefacto `semana09-evidencias` de esa ejecución; las capturas y los registros también se conservan en esta carpeta para que no dependan de la caducidad del artefacto.

## Cómo se obtiene la evidencia

`swift test` ejecuta los archivos originales de `Modelo`, no una reimplementación de sus fórmulas. Comprueba los cuatro casos, el análisis grupal, tasas de AFP, redondeo, recálculo y entradas inválidas. Además exporta los conceptos calculados a [casos-swift.json](evidencias/casos-swift.json).

`xcodebuild test` compila la app SwiftUI y ejecuta cinco pruebas de interfaz. Cada caso se escribe en los TextField y se selecciona mediante los Picker reales. La prueba pulsa Calcular y compara el neto de la pantalla con el esperado. La quinta prueba comprueba el mensaje de sueldo vacío y la ausencia de una boleta válida.

Las capturas son PNG originales adjuntados por XCTest, sin recreación gráfica. El [manifiesto de capturas](evidencias/manifest-capturas.json) conserva la relación con cada prueba y el nombre del dispositivo. Los registros completos de [Swift](evidencias/modelo.log) y [Xcode](evidencias/simulador.log) se guardan junto a ellas.

## Resultados de los cuatro casos

| Caso | Remuneraciones | Descuentos | EsSalud | Neto Excel | Neto Swift / app | Diferencia neta |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 2500.00 | 325.00 | 225.00 | 2175.00 | 2175.00 | 0.00 |
| 2 | 1743.00 | 226.59 | 156.87 | 1516.41 | 1516.41 | 0.00 |
| 3 | 3253.00 | 621.27 | 292.77 | 2631.73 | 2631.73 | 0.00 |
| 4 | 3574.00 | 562.83 | 321.66 | 3011.17 | 3011.17 | 0.00 |

En Excel, `Casos!X6:X9` contiene los netos ejecutados; `Y6:Y9` calcula la diferencia con sus propias fórmulas. El JSON conserva los resultados de cada concepto, incluidos los que valen cero. Los casos 1–3 también coinciden con las respuestas del documento. El caso 4 es el resultado del equipo para revisión del docente, no una respuesta entregada por este.

## Validaciones revisadas

- Sueldo vacío, cero, negativo o texto inválido: rechazado.
- Días fuera de 1–30, vacíos o fraccionarios: rechazados.
- Horas extras o adelantos negativos: rechazados.
- Adelantos con más de dos decimales: rechazados.
- AFP inexistente cuando se elige AFP: rechazada.
- Coma decimal y campos opcionales vacíos: aceptados.
- Repetir el cálculo: no duplica conceptos ni acumula importes anteriores.
- Modificar el sueldo de Boleta en Excel: actualiza los resultados y no cambia el ejemplo fijo del caso 3 en Explicación.

## Reproducibilidad y límites

Las fuentes y la fecha de consulta están en [FUENTES.md](FUENTES.md). Se valida el modelo simplificado de la actividad: no se añaden bases mínimas, topes ni renta de quinta categoría al cálculo. La prueba en simulador confirma el funcionamiento de esta versión; la exposición del equipo, los casos propios y la revisión del docente son actividades aparte.

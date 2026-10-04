# PROMPTS: Ejercicio 4, venta a plazos

## Prompt de trabajo (CTRFE)

**Contexto.** Estoy desarrollando el laboratorio 06 de Programación en Móviles Avanzados con UIKit, Swift y Storyboard. Ya resolví navegación con `UINavigationController` y paso de `ClienteModel` a una pantalla modal. Este ejercicio se guarda en `Semana 06` de la rama `ai-assisted`.

**Tarea.** Crea la calculadora de venta a plazos de un electrodoméstico. La pantalla «Nueva Venta» recibe nombre, precio unitario, cantidad, meses y tasa mensual en porcentaje. Un segue `Show` desde «Calcular» hasta «Resultado» tiene el identificador `showResultado`. Define `class VentaModel: NSObject` con seis propiedades `Double` (`subtotal`, `igv`, `base`, `intereses`, `total`, `cuota`). Calcula `subtotal = precio × cantidad`, `igv = subtotal × 0.18`, `base = subtotal + igv`, `intereses = base × (tasa / 100) × meses`, `total = base + intereses` y `cuota = total / meses`. Pasa el modelo mediante `prepare(for:sender:)` y muestra las seis salidas.

**Restricciones.** Usa solo clases, `UINavigationController`, `IBOutlet` y el segue de Storyboard, según lo visto hasta la semana 6. No uses Combine, Codable ni persistencia. Explica por qué el modelo es una clase en este ejercicio y si un `struct` impediría pasar datos a la siguiente pantalla.

**Formato.** Entrega archivos Swift listos para un proyecto UIKit, conexiones de Storyboard y una explicación breve de las fórmulas y del paso de datos. Formatea cada resultado con `String(format: "S/. %.2f", valor)`.

**Ejemplo.** Para precio S/. 1200, cantidad 2, plazo 12 meses y tasa mensual 2 %, el subtotal es S/. 2400.00, IGV S/. 432.00, base S/. 2832.00, intereses S/. 679.68, total S/. 3511.68 y cuota S/. 292.64.

## Revisión del resultado asistido

El asistente añadió validación de campos vacíos, valores positivos, números finitos y separador decimal con coma; el enunciado no especificaba ese manejo. Usó `guard` para detener la navegación cuando los datos no sirven. Revisé que las seis fórmulas coincidan con el documento y preparé una prueba de interfaz con el ejemplo anterior.

`VentaModel` es `class` y hereda de `NSObject` porque así lo pide el ejercicio. Un `struct` también podría pasarse a la pantalla siguiente, pero se copiaría su valor; la clase permite compartir una misma instancia. En este flujo solo se leen los resultados, así que la navegación hacia adelante no depende de esa diferencia.

No medí tiempos comparables entre el ejercicio manual de clientes y este. En el manual se siguió paso a paso la creación del formulario, el modelo y la presentación modal; en el asistido hubo menos guía y fue necesario comprobar fórmulas, validaciones y conexiones del segue. La ayuda aceleró la escritura inicial, pero la comprensión se comprobó revisando código y ejecutando la prueba.

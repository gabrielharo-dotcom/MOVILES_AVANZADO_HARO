# Calculadora de venta a plazos

Proyecto UIKit del laboratorio 06 en la rama `ai-assisted`. Abrir `VentaPlazos_UIKit.xcodeproj` en Xcode.

La pantalla **Nueva Venta** reúne cinco campos. El botón **Calcular** activa el segue `Show` con identificador `showResultado`. Antes de navegar, `shouldPerformSegue` valida las entradas y construye `VentaModel`; `prepare(for:sender:)` lo entrega a `ResultadoViewController`. La pantalla **Resultado** muestra seis importes en soles.

Fórmulas: subtotal = precio unitario × cantidad; IGV = subtotal × 18 %; base = subtotal + IGV; intereses = base × (tasa mensual / 100) × meses; total = base + intereses; cuota = total / meses. La tasa corresponde al interés simple mensual indicado en el laboratorio.

Ejemplo de verificación: S/. 1200 × 2, 12 meses y 2 % mensual producen subtotal S/. 2400.00, IGV S/. 432.00, base S/. 2832.00, intereses S/. 679.68, total S/. 3511.68 y cuota S/. 292.64.

La prueba de interfaz comprueba esos importes y que una venta incompleta muestre un aviso sin navegar. Se ejecuta en Xcode 15.4 con el simulador iPhone 15 (iOS 17.5).

- [Formulario en iPhone 15](../Evidencias/venta-formulario-iphone15.jpg)
- [Resultado en iPhone 15](../Evidencias/venta-resultado-iphone15.jpg)

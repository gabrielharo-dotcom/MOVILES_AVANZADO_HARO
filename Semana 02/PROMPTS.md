# Prompts utilizados - Laboratorio 02 (Rama: ai-assisted)

## Herramienta de IA utilizada
- ChatGPT / Claude / Gemini

---

## Ejercicio 6: Carrito Mejorado con IA
### Prompt (estructura CTRFE):
- **CONTEXTO:** Desarrollo de un laboratorio en Swift Playgrounds para la materia Programación en Móviles Avanzado. Se requiere implementar la lógica de negocio extendida para un carrito de compras.
- **TAREA:** Crear un script en Swift que procese la compra de 5 productos distintos aplicando descuentos por cantidad, validación de cupones, cálculo de costo de envío, impuestos (IGV) y puntos de fidelidad.
- **RESTRICCIONES:** 
  1. No utilizar colecciones (arrays, diccionarios ni tuplas), únicamente variables y constantes simples.
  2. Incluir una estructura de validación inicial para asegurar que los precios no sean negativos y las cantidades sean mayores a 0.
  3. Formatear las salidas de los importes a 2 decimales usando `String(format: "%.2f", ...)`.
  4. Comentar **CADA LÍNEA** del código explicando detalladamente qué hace.
- **FORMATO:** Código fuente ejecutable en Swift y compatible con la Terminal (`swift`).
- **EJEMPLO DE SALIDA:** Un ticket estructurado de compra impreso en consola.

### ¿Funcionó a la primera?
Sí, la estructura condicional manejó de forma adecuada los subtotales e imprimió el ticket con el formato exacto de decimales.

### ¿La IA usó algo que no conocías?
El uso de `String(format: "%.2f", ...)` junto con `import Foundation` para limitar los decimales en la consola de Swift CLI.

---

## Ejercicio 7: Juego de Adivinanza de Números
### Prompt (estructura CTRFE):
- **CONTEXTO:** Simulación interactiva de un minijuego en Swift Playgrounds sin interacción de consola activa (`readLine`).
- **TAREA:** Construir una simulación del juego "Adivina el número secreto" que evalúe secuencialmente los intentos de un usuario.
- **RESTRICCIONES:** 
  1. Definir un número secreto constante.
  2. Simular exactamente 5 intentos mediante variables fijas (`intento1`, `intento2`, etc.).
  3. Controlar la ejecución mediante un bucle `while` usando un contador (`intentoActual`) y una bandera booleana (`gano`) para detener la ejecución inmediatamente al acertar.
  4. Imprimir si cada intento fue "Muy alto", "Muy bajo" o "¡Correcto!".
  5. Mostrar un mensaje de felicitaciones indicando el número de intentos si gana, o un mensaje de derrota revelando el número secreto si agota los 5 turnos.
  6. Comentar **CADA LÍNEA** del código.
- **FORMATO:** Código Swift listo para compilar y ejecutar.

### ¿Funcionó a la primera?
Sí, el control del bucle `while` combinando la bandera `!gano` funcionó correctamente para cortar el proceso al adivinar en el cuarto intento.

### ¿La IA usó algo que no conocías?
No, se ajustó completamente a las estructuras condicionales `if/else`, variables escalares y bucles `while` vistos en clase.

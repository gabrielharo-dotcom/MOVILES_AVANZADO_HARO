# Prompts utilizados - Laboratorio 02

## Herramienta de IA utilizada
[GEMINI PRO]

## Ejercicio 6: Carrito mejorado
### Prompt (estructura CTRFE):
- **CONTEXTO:** Desarrollo de un script en Swift Playgrounds para la materia Programación en Móviles Avanzado.
- **TAREA:** Extender las funcionalidades del ejercicio 5 del carrito de compras simplificado.
- **RESTRICCIONES:** 
  1. No utilizar arrays ni diccionarios (aún no se han cubierto en el curso). Usa únicamente variables simples, condicionales `if/else`, `switch` y bucles.
  2. Comenta **CADA LÍNEA** del código explicando detalladamente qué hace.
- **FORMATO:** Código Swift listo para ejecutar en Xcode Playground.
- **EJEMPLO:** `let precio1 = 3500.0 // Almacena el precio base del producto Laptop`

### Requisitos a implementar:
1. Descuento por cantidad: si compra 3 o más unidades del mismo producto, aplicar 5% extra en ese producto.
2. Cupón de descuento: si el código del cupón es "DESCUENTO20", aplicar 20% adicional al total.
3. Envío gratis: si el total supera S/. 3000, el envío es gratis. Si no, cuesta S/. 25.00.
4. Puntos de fidelidad: por cada S/. 100 de compra, el cliente gana 1 punto. Mostrar puntos ganados.
5. Validación: si algún precio es negativo o alguna cantidad es 0, mostrar error.

### ¿Funcionó a la primera?
Sí, generó la lógica completa respetando las restricciones de no usar colecciones.

### ¿La IA usó algo que no conocías?
No, se mantuvo en el scope del laboratorio 02.

---

## Ejercicio 7: Juego de adivinanza
### Prompt (estructura CTRFE):
- **CONTEXTO:** Simulación de juego en Swift Playgrounds.
- **TAREA:** Crear un mini juego de adivinanza de números usando variables fijas para los intentos.
- **RESTRICCIONES:** 
  1. Número secreto fijo (ejemplo: 42).
  2. Simular 5 intentos con variables (`intento1`, `intento2`, etc.).
  3. Usar un bucle `while` para recorrer los intentos.
  4. Mostrar si el intento es "Muy alto", "Muy bajo" o "¡Correcto!".
  5. Contar cuántos intentos se utilizaron y mostrar si perdió al agotar los 5 intentos.
  6. Comentar **CADA LÍNEA** del código.
- **FORMATO:** Código ejecutable en Swift.

### ¿Funcionó a la primera?
Sí, la simulación iterativa con `while` manejó correctamente la salida anticipada.

### ¿La IA usó algo que no conocías?
Se verificó el uso del flag booleano de corte en el bucle.

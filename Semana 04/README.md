# Semana 04 — Actividades propuestas

Dos Playgrounds de Swift para abrir individualmente en Xcode y ejecutar con la consola visible. La entrega corresponde a las actividades propuestas 01 y 02 del laboratorio 04 y se desarrolla en la rama `Ejercicios`.

## Actividad 01 — Factura de cursos

`Actividad01.playground` modela al alumno, los cursos y las inscripciones con structs. La clase `FacturaCursos` reúne las inscripciones, calcula los importes y muestra la factura.

Los precios ingresados no incluyen IGV. Se suma precio por cantidad y se aplica el IGV del 18 % mostrado en el laboratorio. Al comprar tres o más unidades de cursos, se descuenta el 10 % del total con IGV. Si además el alumno pertenece a Tecsup, se restan S/ 400.00 adicionales. Las cantidades cuentan como unidades compradas; el ejemplo tiene tres cursos distintos y cuatro unidades.

El ejemplo de Juan León compra Swift Avanzado x1 (S/ 450), IA con Python x2 (S/ 650 por unidad) y Diseño UX/UI x1 (S/ 500). Produce un subtotal de S/ 2250.00, IGV de S/ 405.00, total con IGV de S/ 2655.00, descuento porcentual de S/ 265.50 y descuento Tecsup de S/ 400.00. El resultado es **S/ 1989.50**.

No se aceptan cantidades no positivas ni precios negativos. El enunciado no define un tope para el descuento fijo; se conserva su fórmula literal. Para precios muy bajos, esta fórmula podría producir un total negativo. Los datos de la demostración no presentan ese caso.

## Actividad 02 — Clientes

`Actividad02.playground` implementa el diagrama de clases: `Cliente` contiene código, dirección, fecha de registro, número de cuenta y monto mínimo de apertura. `ClienteNatural` agrega nombre completo y DNI; `ClienteJuridico` agrega razón social, RUC y representante legal.

Ambas subclases inicializan los datos comunes mediante `super.init`, sobrescriben `mostrarDatos()` mediante `override` y reutilizan la salida común mediante `super.mostrarDatos()`. El arreglo `[Cliente]` permite recorrer ambos clientes con una misma llamada, que ejecuta el método correspondiente al tipo real de cada instancia.

Se conservan los datos de Juan Pérez y Soluciones SAC de la imagen del laboratorio, incluidas sus fechas de registro de 2025. DNI, RUC y cuenta son cadenas para preservar su formato. Se usa `mostrarDatos` en camelCase, siguiendo la convención de Swift para el método `MostrarDatos()` del diagrama.

## Verificación

Desde Terminal en el Mac, dentro de `Semana 04`, ejecutar:

```bash
bash Pruebas/verificar.sh
```

El script utiliza el Swift de Xcode mediante `xcrun`: comprueba el ejemplo de factura, las fronteras de cero a cuatro cursos para ambos tipos de alumno y entradas inválidas. Después compara toda la salida de clientes con el ejemplo esperado. Finaliza con error ante cualquier diferencia.

También se pueden abrir los dos archivos `.playground` en Xcode y ejecutar su código para observar cada demostración. Las pruebas se ejecutaron correctamente en macOS 14 con Apple Swift 5.10, usando las herramientas de Xcode.

## Desarrollo

Código preparado con asistencia de Codex a partir del enunciado y sus imágenes. La progresión de cada actividad es: modelos iniciales, reglas o herencia, y demostración con comprobaciones. Las fechas de autor y de commit solicitadas para esta entrega son del 14 de septiembre de 2026, zona horaria de Lima.

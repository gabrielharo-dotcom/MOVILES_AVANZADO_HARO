# Explicación del trabajo grupal

## Explicar el Excel

1. Abrir **Parámetros**. Señalar RMV, ONP, EsSalud, recargos y tasas por AFP. Los valores se mantienen en un solo lugar y tienen fuente y fecha de consulta.
2. Abrir **Boleta**. Las entradas amarillas corresponden al caso 3. Cambiar el sueldo y mostrar cómo se actualizan remuneraciones, descuentos, EsSalud y neto. Restaurar después el caso 3: 3000, 30 días, hijos Sí, AFP Ejemplo, 4 y 4 horas extras, adelanto 200.
3. Explicar el sueldo computable: 3000 ÷ 30 × 30 = 3000. La asignación familiar es 123 y no se prorratea. El valor hora es 12.50; los recargos producen 62.50 y 67.50. Total: 3253.
4. Explicar la AFP: 325.30 al fondo, 52.05 de comisión y 43.92 de seguro. Cada concepto se redondea primero. Con el adelanto de 200, los descuentos son 621.27 y el neto 2631.73.
5. Explicar EsSalud: 292.77 lo paga la empresa y no reduce el neto. El costo simplificado del trabajador es 3545.77.
6. Abrir **Explicación** para leer cada fórmula en palabras y su ejemplo. Abrir **Casos** para contrastar los cuatro resultados con la app y las diferencias de cero al centavo.

## Explicar la app SwiftUI

1. Abrir `BoletaPago/BoletaPago.xcodeproj` en Xcode y ejecutar el esquema BoletaPago en un iPhone del simulador.
2. Mostrar que solo existe una pantalla: un `ScrollView` contiene el formulario, el botón y los resultados. Los campos usan `@State` para conservar lo escrito.
3. Ejecutar el caso 1 (2500, 30 días, sin hijos, ONP). Debe producir 2175.00 de neto.
4. Ejecutar el caso 3 y explicar por qué aparece el selector de AFP solo al elegir AFP. Mostrar los tres bloques y el neto de 2631.73.
5. Dejar el sueldo vacío o escribir cero y pulsar Calcular. Explicar el mensaje y que no se muestra una boleta válida con datos incorrectos.
6. Abrir `Modelo`: `DatosBoleta` y `Concepto` son structs; `Boleta` es la clase que calcula; `Parametros` contiene constantes y un diccionario por AFP. Los arrays conservan los conceptos, incluso cuando su monto es cero.
7. Explicar que `Decimal` evita trabajar con importes monetarios binarios y que `NSDecimalRound` aplica dos decimales por concepto. La vista presenta los resultados y no contiene fórmulas de negocio.

## Preguntas grupales

Las respuestas 1–4 están desarrolladas en [ANALISIS.md](ANALISIS.md). Cada integrante debe poder explicar por qué AFP Ejemplo deja S/ 1.62 más que ONP en el caso 3, por qué el costo para la empresa supera el sueldo y por qué un aumento del bruto no se traslada íntegro al neto.

Los casos propios por integrante y la pregunta 5 siguen pendientes de sus datos reales. No se presentan como resultados completados.

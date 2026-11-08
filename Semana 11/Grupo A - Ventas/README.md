# Ventas Tecsup · Grupo A

Gabriel Haro · Programación en Móviles Avanzado · Semana 11

App iOS para gestionar productos, clientes y ventas. Usa UIKit, un `UITabBarController` por rol y una base local SQLite administrada por Core Data. Incluye el alcance base, los filtros del Nivel + y el resumen del reto.

## Ejecutar en Xcode

1. Abre `VentasTecsup.xcodeproj` en una Mac con Xcode y selecciona el esquema `VentasTecsup`.
2. Elige un simulador de iPhone con iOS 16 o posterior. Pulsa **Run**. Para probar en un iPhone físico, selecciona tu equipo de firma en el target.
3. Crea una cuenta de **Supervisor**. Agrega productos y clientes. Cierra sesión y crea una cuenta de **Vendedor** para registrar ventas. Puedes volver a entrar como supervisor para revisar y anular las ventas de esa misma base local.

La base comienza vacía. En esta práctica la clave se almacena como texto y el rol se elige en el registro.

## Pantallas

| Pantalla | Función |
| --- | --- |
| A1 · Ingreso | Usuario, clave oculta y error genérico de credenciales |
| A2 · Crear cuenta | Nombre, usuario único, validación de claves, elección de rol e ingreso inmediato |
| A3 · Productos | Búsqueda, filtros de categoría y color por stock. El supervisor administra el catálogo |
| A4 · Clientes | Búsqueda, alta y edición. El supervisor puede borrar clientes sin ventas |
| A5 · Nueva venta | Vendedor de la sesión, cliente, producto, cantidad, stock, descuento, IGV y total |
| A6 · Mis ventas | Ventas del vendedor actual, indicadores propios y filtros por fecha y cliente |
| A7 · Ventas del equipo | Ventas por fecha, vendedor y cliente, con el nombre del vendedor |
| A8 · Anular venta | Alerta del supervisor con motivo obligatorio y devolución del stock |
| A9 · Resumen | Vendido hoy frente a ayer, IGV mensual, gráfico de siete días, ranking y stock bajo |
| Cuenta | Nombre, usuario, rol y cierre de sesión |

## Datos y reglas

- `Usuario`, `Producto` y `Cliente` tienen relaciones inversas hacia `Venta` con regla de borrado `Deny`. Las ventas anuladas conservan las relaciones y el motivo.
- Regular por debajo de S/ 1 000, Frecuente desde S/ 1 000 y VIP desde S/ 5 000, según la suma de ventas activas. El descuento VIP es 10 % y el IGV es 18 % de la base con descuento.
- La venta guarda el precio aplicado, sus importes y el vendedor. El stock y la venta se guardan juntos. Anular reintegra el stock una sola vez y excluye la venta del resumen y la categoría.
- `Historial.swift` aplica `NSPredicate` al periodo, vendedor y cliente. `Resumen.swift` consulta ventas activas del mes y de los últimos siete días, además de los productos con stock ≤ 5.

## Entrega y pruebas

El [expediente técnico](Expediente%20Grupo%20A%20Ventas.docx) contiene el modelo de datos, la matriz de permisos, las maquetas, los nueve casos de prueba y el plan de commits. [PROMPTS.md](PROMPTS.md) registra el uso de IA.

Para reproducir el caso VIP, vende primero un producto de S/ 4 500 al cliente. El total con IGV será S/ 5 310 y su categoría pasará a VIP. Luego vende dos Laptop de S/ 200 con stock inicial de 40. El total esperado es S/ 424,80 y quedan 38 unidades. Al anular, vuelven a 40 unidades.

La compilación y los casos de la app requieren ejecutar el proyecto en Xcode. Los resultados de la tabla del expediente son los resultados esperados.

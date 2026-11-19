# Expediente de planificación manual (borrador)

Proyecto: Grupo A Ventas — UIKit + Core Data. Responsable del repositorio: Gabriel Haro.

## Modelo propuesto
- Usuario: nombre, usuario, clave, rol; ventas (Deny).
- Producto: nombre, categoria, precio, stock; ventas (Deny).
- Cliente: nombre, documento; ventas (Deny).
- Venta: fecha, cantidad, precioUnitario, descuento, igv, total, anulada, motivoAnulacion; vendedor, producto y cliente.

## Roles
- Vendedor: Productos/Clientes (consulta), Nueva venta, Mis ventas, Cuenta.
- Supervisor: Resumen, Ventas del equipo, Productos/Clientes (administración), Cuenta.

## Negocio
VIP desde S/5 000 acumulados no anulados: descuento 10%. IGV 18% de base después del descuento. Regular menos de S/1 000 y Frecuente desde S/1 000. Al anular se devuelve stock y se excluye de reportes.

## Bocetos y decisiones del equipo
Añadir aquí las nueve pantallas diseñadas manualmente y los casos de prueba realmente propuestos. Este documento es una plantilla, no evidencia de ejecución independiente.

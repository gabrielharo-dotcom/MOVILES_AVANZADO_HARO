# Mi expediente inicial (borrador)

Elegí el caso Grupo A: Ventas con UIKit + Core Data. Planteé cuatro entidades: Usuario (nombre, usuario, clave, rol), Producto (nombre, categoría, precio, stock), Cliente (nombre, documento) y Venta (fecha, cantidad, precioUnitario, descuento, IGV, total, anulada, motivo y relaciones).

Definí los roles Vendedor y Supervisor y la relación uno a muchos desde Usuario, Producto y Cliente hacia Venta, con regla de borrado Deny. Para la siguiente etapa planifiqué completar las nueve pantallas, el control de stock, el IGV, los descuentos y la anulación.

En mi prototipo base solamente puedo probar el acceso, el registro de cuenta y la creación y lectura de productos en Core Data. Todavía me falta validar la funcionalidad completa.

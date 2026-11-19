# Pruebas que debo realizar

Voy a abrir la aplicación en Xcode 26.3 y registrar los resultados verdaderos de estas pruebas. Aún no las marco como aprobadas.

- [ ] Compruebo que no puedo registrar dos usuarios iguales con distintas mayúsculas.
- [ ] Compruebo el mínimo de seis caracteres de la clave y su confirmación.
- [ ] Verifico que el mensaje de login incorrecto sea genérico.
- [ ] Registro una venta VIP de 2 unidades a S/ 200: espero subtotal S/ 400, descuento S/ 40, IGV S/ 64.80 y total S/ 424.80.
- [ ] Registro una venta regular de 3 unidades a S/ 35: espero subtotal S/ 105, IGV S/ 18.90 y total S/ 123.90.
- [ ] Intento vender más unidades que el stock disponible.
- [ ] Compruebo que el Vendedor solo vea sus ventas y no pueda anularlas.
- [ ] Compruebo que el Supervisor anule con motivo, devuelva stock y excluya la venta del resumen.
- [ ] Intento eliminar un producto o cliente que ya tiene ventas.
- [ ] Cierro y reinicio la aplicación para verificar la persistencia de Core Data.

Registraré capturas reales y errores encontrados después de ejecutar las pruebas.

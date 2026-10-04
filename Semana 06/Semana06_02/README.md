# Datos del cliente

Proyecto UIKit con Storyboard para la parte de ventanas modales del laboratorio 06.

El formulario solicita apellidos, nombres y DNI; `ClienteModel` agrupa esos datos para enviarlos a la pantalla de confirmación.

**Continuar** valida los campos, crea el modelo y presenta `ViewControllerConfirmacion` de forma modal. **Volver** cierra la hoja y conserva el formulario para corregir los datos.

La prueba `Semana06_02UITests.testPresentacionModalDeCliente` comprueba el paso de datos y el regreso; `testDNIInvalidoMuestraAviso` comprueba el aviso de validación. Ambas pasaron en Xcode 15.4 con el simulador iPhone 15 (iOS 17.5).

- [Formulario](../Evidencias/cliente-formulario-iphone15.png)
- [Confirmación modal](../Evidencias/cliente-confirmacion-iphone15.png)

Abrir `Semana06_02.xcodeproj` en Xcode.

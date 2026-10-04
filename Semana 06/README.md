# Semana 06: vistas y navegación con UIKit

En `main`:

- [Navegacion_UIKit](Navegacion_UIKit): `UINavigationController` y segue `Show` entre dos pantallas.
- [Semana06_02](Semana06_02): captura de datos de un cliente y presentación modal de la confirmación.

La calculadora de venta a plazos y su `PROMPTS.md` se desarrollan en la rama `ai-assisted`.

## Evidencias

- [Navegación: pantalla 1](Evidencias/navegacion-pantalla1-iphone15.png)
- [Navegación: pantalla 2](Evidencias/navegacion-pantalla2-iphone15.png)
- [Icono Tecsup en el inicio del iPhone](Evidencias/navegacion-icono-iphone15.jpg)
- [Datos del cliente: formulario](Evidencias/cliente-formulario-iphone15.png)
- [Datos del cliente: confirmación modal](Evidencias/cliente-confirmacion-iphone15.png)

## Preguntas de navegación

Al insertar un `UINavigationController`, la primera vista queda como raíz de una pila y aparece la barra de navegación. `Show` es apropiado para avanzar a una pantalla de detalle dentro de esa pila, por ejemplo, de una lista de productos a un producto; la barra aporta el botón para regresar. `Present Modally` conviene para una tarea temporal que se cierra al terminar, como confirmar los datos de un cliente. [Referencia de UIKit](https://developer.apple.com/documentation/uikit/uinavigationcontroller)

`Show Detail` está pensado para presentar o sustituir el contenido de detalle según el contenedor. En una interfaz dividida de iPad puede actualizar el panel de detalle; en un `UINavigationController` simple se presenta de forma modal. `Present As Popover` ofrece contenido contextual junto a un control en una pantalla amplia, como iPad; en un ancho compacto se adapta a una presentación modal. [Referencia de segues de UIKit](https://developer.apple.com/documentation/uikit/customizing-the-behavior-of-segue-based-presentations)

`ClienteModel` es una clase porque el ejercicio pide una clase derivada de `NSObject`. Pasar un `struct` a la siguiente vista también funcionaría tras adaptar el tipo: se copiaría el valor. Con una clase ambas vistas pueden compartir la misma instancia y observar cambios posteriores; con un `struct`, cada copia cambia por separado. [Referencia de Swift](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)

# Mi diseño de nueve pantallas — copia de referencia

Conservé las nueve maquetas del Storyboard que había generado, pero **retiré el archivo de los recursos de mi aplicación** porque Xcode dejó de abrir el proyecto después de agregarlo. Lo guardé como `Pantallas.storyboard.xml` dentro de `Documentacion`, donde no lo interpreto como un recurso compilable de Xcode. De esta manera puedo recuperar el proyecto con el punto de entrada UIKit programático que utilizaba antes.

No afirmo que esta versión del Storyboard esté validada por Interface Builder: todavía debo reconstruirla y comprobarla en mi Mac. Mis nueve pantallas funcionales de `main` y `ai-assisted` siguen en los archivos Swift (A1 Ingreso, A2 Registro, A3 Productos, A4 Clientes, A5 Nueva venta, A6 Mis ventas, A7 Ventas del equipo, A8 Anulación y A9 Resumen); la navegación principal la realizo con `UINavigationController` y `UITabBarController` desde `App.swift`.

Para comprobar mi aplicación, abro `VentasTecsup.xcodeproj`, compilo con Cmd+B y ejecuto con Cmd+R. Si aún se cierra Xcode, revisaré el informe de fallo y la consola para determinar la causa real.

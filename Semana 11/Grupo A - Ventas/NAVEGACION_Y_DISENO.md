# Cómo reviso las nueve pantallas en UIKit

Guardé mi archivo `Pantallas.storyboard` **dentro de `VentasTecsup`**, para verlo en el navegador de Xcode. El documento contiene el Navigation Controller principal y las maquetas A1–A9.

Para **ejecutar la app**, abro `VentasTecsup.xcodeproj`. Mi aplicación inicia por `SceneDelegate` en `App.swift`, presenta el ingreso y, después del inicio de sesión, muestra las pestañas según mi rol mediante `UITabBarController`. Las interfaces funcionales están creadas mediante UIKit en archivos Swift; el Storyboard es visual y no sustituye esos controladores.

Mantengo la implementación base en `manual` y la versión avanzada en `ai-assisted` y `main`. No he comprobado todavía la apertura del proyecto en Xcode 26.3 después de esta corrección, así que debo compilar y probar en mi Mac.

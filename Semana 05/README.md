# Semana 05: UIKit

- **Ejemplo y proyecto 1:** `apple_lab05_UIKit_intro`. Los primeros tres commits crean el ejemplo con una etiqueta; los siguientes tres agregan el nombre y las restricciones para rotación.
- **Proyecto 2:** `IMC_UIKit`. Tres commits crean el proyecto, conectan los controles del storyboard e implementan el cálculo del IMC.

Cada carpeta contiene un proyecto `.xcodeproj` que se abre con Xcode. La actividad de la calculadora de préstamos queda reservada para otra rama.

## Evidencias

- [Proyecto 1 en iPhone 15](Evidencias/proyecto1-iphone15.png)
- [Proyecto 1 en horizontal](Evidencias/proyecto1-horizontal-iphone15.png)
- [Formulario de IMC](Evidencias/imc-inicial-iphone15.png)
- [Resultado de IMC con 70 kg y 1,70 m](Evidencias/imc-resultado-iphone15.png)

Ambos proyectos compilaron y se ejecutaron con Xcode 15.4 en el simulador iPhone 15 (iOS 17.5). La prueba de interfaz `apple_lab05_UIKit_introUITests.testEtiquetasEnHorizontal` confirmó que ambas etiquetas permanecen visibles al girar el dispositivo. La prueba `IMC_UIKitUITests.testCalculoIMC` confirmó el resultado `IMC: 24.22 - Peso normal`.

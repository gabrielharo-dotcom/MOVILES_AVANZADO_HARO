# Proyecto 2: calculadora de IMC

Ingresar peso en kilogramos y altura en metros, luego pulsar **Mostrar**. La aplicación calcula `peso / altura²` y presenta el IMC con su categoría. Acepta punto o coma decimal y muestra un aviso si los valores no son positivos.

Abrir `IMC_UIKit.xcodeproj` en Xcode y ejecutar en un simulador de iPhone.

La prueba de interfaz `IMC_UIKitUITests.testCalculoIMC` ingresa 70 kg y 1,70 m, pulsa **Mostrar**, comprueba `IMC: 24.22 - Peso normal` y conserva una captura del resultado.

# Ejercicio: calculadora de préstamos

Aplicación iOS con UIKit y Storyboard para calcular la cuota mensual y el total a pagar de un préstamo amortizado. Ingresa el capital inicial, la tasa de interés anual en porcentaje y el plazo en años enteros.

La tasa mensual es la tasa anual porcentual dividida entre 1200. Para `n = años × 12` pagos y tasa mensual `r`, se aplica `cuota = capital × r(1+r)^n / ((1+r)^n - 1)`. El total es `cuota × n`. Si la tasa es cero, la cuota es `capital / n`. Se aceptan punto y coma decimal; los importes se muestran con dos decimales, en la misma moneda del capital. Los datos fuera de rango muestran un aviso.

Abrir `Prestamos_UIKit.xcodeproj` en Xcode.

Las pruebas `Prestamos_UIKitUITests` cubren un préstamo con interés, otro sin interés y un capital inválido. La [captura del resultado](../Evidencias/prestamos-resultado-iphone15.png) corresponde a 10000 de capital, 12 % anual y 1 año.

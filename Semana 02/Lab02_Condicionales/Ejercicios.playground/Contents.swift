import Foundation // Importa Foundation para poder mostrar importes con dos decimales.

// ===== EJERCICIO 6: CARRITO MEJORADO - ASISTIDO POR IA =====

let prod1 = "Silla Ergonomica" // Guarda el nombre del primer producto.
let precio1 = 450.0 // Guarda el precio unitario de la silla.
let cant1 = 1 // Guarda la cantidad comprada de sillas.
let prod2 = "Escritorio" // Guarda el nombre del segundo producto.
let precio2 = 750.0 // Guarda el precio unitario del escritorio.
let cant2 = 1 // Guarda la cantidad comprada de escritorios.
let prod3 = "Lampara LED" // Guarda el nombre del tercer producto.
let precio3 = 85.0 // Guarda el precio unitario de la lámpara.
let cant3 = 4 // Guarda cuatro lámparas para probar el descuento por cantidad.
let prod4 = "Organizador" // Guarda el nombre del cuarto producto.
let precio4 = 35.0 // Guarda el precio unitario del organizador.
let cant4 = 2 // Guarda la cantidad comprada de organizadores.
let prod5 = "Cuaderno Anillado" // Guarda el nombre del quinto producto.
let precio5 = 12.0 // Guarda el precio unitario del cuaderno.
let cant5 = 5 // Guarda cinco cuadernos para probar el descuento por cantidad.
let codigoCupon = "DESCUENTO20" // Guarda el cupón que se validará antes de aplicarlo.

let datosValidos = precio1 >= 0 && cant1 > 0 && precio2 >= 0 && cant2 > 0 && precio3 >= 0 && cant3 > 0 && precio4 >= 0 && cant4 > 0 && precio5 >= 0 && cant5 > 0 // Comprueba que todos los precios y cantidades sean válidos.

if datosValidos { // Ejecuta los cálculos solamente cuando todos los datos son válidos.
    let sub1 = precio1 * Double(cant1) // Calcula el subtotal inicial de las sillas.
    let sub2 = precio2 * Double(cant2) // Calcula el subtotal inicial de los escritorios.
    let sub3 = precio3 * Double(cant3) // Calcula el subtotal inicial de las lámparas.
    let sub4 = precio4 * Double(cant4) // Calcula el subtotal inicial de los organizadores.
    let sub5 = precio5 * Double(cant5) // Calcula el subtotal inicial de los cuadernos.

    var descuentoCantidad1 = 0.0 // Inicializa el descuento por cantidad de la silla.
    var descuentoCantidad2 = 0.0 // Inicializa el descuento por cantidad del escritorio.
    var descuentoCantidad3 = 0.0 // Inicializa el descuento por cantidad de la lámpara.
    var descuentoCantidad4 = 0.0 // Inicializa el descuento por cantidad del organizador.
    var descuentoCantidad5 = 0.0 // Inicializa el descuento por cantidad del cuaderno.

    if cant1 >= 3 { // Verifica si se compraron tres o más sillas.
        descuentoCantidad1 = sub1 * 0.05 // Aplica 5% de descuento al subtotal de las sillas.
    } // Cierra la validación de cantidad de sillas.
    if cant2 >= 3 { // Verifica si se compraron tres o más escritorios.
        descuentoCantidad2 = sub2 * 0.05 // Aplica 5% de descuento al subtotal de los escritorios.
    } // Cierra la validación de cantidad de escritorios.
    if cant3 >= 3 { // Verifica si se compraron tres o más lámparas.
        descuentoCantidad3 = sub3 * 0.05 // Aplica 5% de descuento al subtotal de las lámparas.
    } // Cierra la validación de cantidad de lámparas.
    if cant4 >= 3 { // Verifica si se compraron tres o más organizadores.
        descuentoCantidad4 = sub4 * 0.05 // Aplica 5% de descuento al subtotal de los organizadores.
    } // Cierra la validación de cantidad de organizadores.
    if cant5 >= 3 { // Verifica si se compraron tres o más cuadernos.
        descuentoCantidad5 = sub5 * 0.05 // Aplica 5% de descuento al subtotal de los cuadernos.
    } // Cierra la validación de cantidad de cuadernos.

    let totalProducto1 = sub1 - descuentoCantidad1 // Resta a la silla su descuento por cantidad.
    let totalProducto2 = sub2 - descuentoCantidad2 // Resta al escritorio su descuento por cantidad.
    let totalProducto3 = sub3 - descuentoCantidad3 // Resta a la lámpara su descuento por cantidad.
    let totalProducto4 = sub4 - descuentoCantidad4 // Resta al organizador su descuento por cantidad.
    let totalProducto5 = sub5 - descuentoCantidad5 // Resta al cuaderno su descuento por cantidad.
    let subtotal = totalProducto1 + totalProducto2 + totalProducto3 + totalProducto4 + totalProducto5 // Suma los productos después del descuento por cantidad.

    var porcentajeDescuento = 0.0 // Inicializa el porcentaje de descuento general de la compra.
    if subtotal >= 5000 { // Comprueba si la compra alcanza el nivel de 15%.
        porcentajeDescuento = 0.15 // Asigna 15% de descuento general.
    } else if subtotal >= 2000 { // Comprueba si la compra alcanza el nivel de 10%.
        porcentajeDescuento = 0.10 // Asigna 10% de descuento general.
    } else if subtotal >= 500 { // Comprueba si la compra alcanza el nivel de 5%.
        porcentajeDescuento = 0.05 // Asigna 5% de descuento general.
    } // Cierra la selección del descuento general.

    let descuentoGeneral = subtotal * porcentajeDescuento // Calcula el dinero descontado por el monto de compra.
    let subtotalConDescuento = subtotal - descuentoGeneral // Resta el descuento general al subtotal.
    let igv = subtotalConDescuento * 0.18 // Calcula el IGV del 18% después de los descuentos.
    let totalConIGV = subtotalConDescuento + igv // Suma el IGV al subtotal con descuento.

    var descuentoCupon = 0.0 // Inicializa en cero el descuento adicional del cupón.
    if codigoCupon == "DESCUENTO20" { // Comprueba que el texto del cupón sea exactamente el solicitado.
        descuentoCupon = totalConIGV * 0.20 // Calcula 20% adicional sobre el total con IGV.
    } // Cierra la validación del cupón.
    let totalConCupon = totalConIGV - descuentoCupon // Resta del total el descuento adicional del cupón.

    var costoEnvio = 25.0 // Establece S/. 25 como costo de envío inicial.
    if totalConCupon > 3000 { // Comprueba si el total supera S/. 3000.
        costoEnvio = 0.0 // Convierte el envío en gratuito cuando se supera el monto requerido.
    } // Cierra la validación del envío gratis.

    let totalFinal = totalConCupon + costoEnvio // Agrega el costo de envío al total después del cupón.
    let puntosFidelidad = Int(totalConCupon / 100) // Entrega un punto completo por cada S/. 100 de compra.

    var separador = "" // Crea una cadena vacía para formar la línea del ticket.
    for _ in 1...48 { // Repite 48 veces la construcción de la línea separadora.
        separador += "=" // Agrega un signo igual en cada repetición.
    } // Cierra el bucle que construye el separador.

    print(separador) // Imprime la primera línea del ticket.
    print("        CARRITO MEJORADO (IA)") // Imprime el título del ticket.
    print(separador) // Separa el título del detalle de productos.
    print("\(prod1) x\(cant1): S/. \(String(format: "%.2f", totalProducto1))") // Imprime el total de sillas después del descuento por cantidad.
    print("\(prod2) x\(cant2): S/. \(String(format: "%.2f", totalProducto2))") // Imprime el total de escritorios después del descuento por cantidad.
    print("\(prod3) x\(cant3): S/. \(String(format: "%.2f", totalProducto3))") // Imprime el total de lámparas después del descuento por cantidad.
    print("\(prod4) x\(cant4): S/. \(String(format: "%.2f", totalProducto4))") // Imprime el total de organizadores después del descuento por cantidad.
    print("\(prod5) x\(cant5): S/. \(String(format: "%.2f", totalProducto5))") // Imprime el total de cuadernos después del descuento por cantidad.
    print(separador) // Separa los productos del resumen de la compra.
    print("Subtotal: S/. \(String(format: "%.2f", subtotal))") // Imprime el subtotal después del descuento por cantidad.
    print("Descuento general (\(Int(porcentajeDescuento * 100))%): -S/. \(String(format: "%.2f", descuentoGeneral))") // Imprime el descuento general según el monto.
    print("IGV (18%): S/. \(String(format: "%.2f", igv))") // Imprime el IGV calculated.
    print("Cupón \(codigoCupon): -S/. \(String(format: "%.2f", descuentoCupon))") // Imprime el descuento adicional del cupón.
    print("Envío: \(costoEnvio == 0 ? "GRATIS" : "S/. \(String(format: "%.2f", costoEnvio))")") // Indica si el envío es gratis o muestra su costo.
    print(separador) // Separa el resumen del total final.
    print("TOTAL: S/. \(String(format: "%.2f", totalFinal))") // Imprime el total final que pagará el cliente.
    print("Puntos ganados: \(puntosFidelidad) pts") // Imprime los puntos completos obtenidos por la compra.
    print(separador) // Imprime la última línea del ticket.
} else { // Ejecuta esta alternativa cuando existe un precio o una cantidad inválida.
    print("Error: los precios no pueden ser negativos y las cantidades deben ser mayores que 0.") // Informa claramente por qué no se procesó la compra.
} // Cierra la validación general de los datos del carrito

// ==========================================
// ===== EJERCICIO 7: JUEGO DE ADIVINANZA ===
// ==========================================

let numeroSecreto = 42 // Guarda el número exacto que el jugador debe adivinar.
let intento1 = 15 // Primer intento simulado para evaluar la respuesta del sistema.
let intento2 = 60 // Segundo intento simulado para evaluar la respuesta del sistema.
let intento3 = 35 // Tercer intento simulado para evaluar la respuesta del sistema.
let intento4 = 42 // Cuarto intento simulado donde se acierta el número secreto.
let intento5 = 50 // Quinto intento simulado en caso de requerir continuar la iteración.

var intentoActual = 1 // Lleva el control numérico del turno actual de adivinanza.
var gano = false // Bandera booleana para registrar si el jugador acertó la cifra.

print("=== JUEGO DE ADIVINANZA DE NÚMEROS ===") // Muestra el mensaje de bienvenida al minijuego.

while intentoActual <= 5 && !gano { // Mantiene el bucle activo mientras queden intentos y no se haya ganado.
    var intentoNumero = 0 // Inicializa la variable temporal que recibirá el número de cada turno.
    
    if intentoActual == 1 { // Verifica si el bucle está procesando el primer turno.
        intentoNumero = intento1 // Asigna el valor fijado para el primer intento.
    } else if intentoActual == 2 { // Verifica si el bucle está procesando el segundo turno.
        intentoNumero = intento2 // Asigna el valor fijado para el segundo intento.
    } else if intentoActual == 3 { // Verifica si el bucle está procesando el tercer turno.
        intentoNumero = intento3 // Asigna el valor fijado para el tercer intento.
    } else if intentoActual == 4 { // Verifica si el bucle está procesando el cuarto turno.
        intentoNumero = intento4 // Asigna el valor fijado para el cuarto intento.
    } else if intentoActual == 5 { // Verifica si el bucle está procesando el quinto turno.
        intentoNumero = intento5 // Asigna el valor fijado para el quinto intento.
    } // Cierra la estructura condicional de selección del intento actual.

    if intentoNumero == numeroSecreto { // Comprueba si el número ingresado es exactamente igual al secreto.
        print("Intento \(intentoActual): \(intentoNumero) -> ¡Correcto!") // Informa el acierto exitoso en la consola.
        gano = true // Cambia la bandera a verdadero para terminar el bucle de inmediato.
    } else if intentoNumero > numeroSecreto { // Comprueba si el valor ingresado es mayor al número secreto.
        print("Intento \(intentoActual): \(intentoNumero) -> Muy alto") // Muestra la pista indicando que la cifra es alta.
    } else { // Ejecuta este bloque si el número es menor al número secreto.
        print("Intento \(intentoActual): \(intentoNumero) -> Muy bajo") // Muestra la pista indicando que la cifra es baja.
    } // Cierra la evaluación de pistas del juego.

    if !gano { // Comprueba si el jugador aún no ha adivinado el número.
        intentoActual += 1 // Incrementa en 1 el contador para pasar al siguiente turno.
    } // Cierra la actualización del contador de intentos.
} // Cierra el bucle de iteración del minijuego.

if gano { // Evalúa si la partida finalizó con una victoria del usuario.
    print("¡Felicidades! Adivinaste el número en el intento \(intentoActual).") // Muestra el mensaje de felicitación e intentos utilizados.
} else { // Ejecuta este bloque si se agotaron todos los turnos sin ganar.
    print("Agotaste tus 5 intentos. El número secreto era: \(numeroSecreto).") // Notifica al jugador la derrota y revela el número.
} // Cierra el mensaje final sobre el resultado del juego.

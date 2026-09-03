// Desarrollado por: Gabriel Haro
// ==========================================
import Foundation
// TODO 1: Registro de 5 alumnos
// ==========================================
print("\n--- TODO 1: Registro de Alumnos ---")
var alumnos: [String] = []

for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}
print("Alumnos registrados: \(alumnos)")

// ==========================================
// TODO 2: Buscar un alumno
// ==========================================
print("\n--- TODO 2: Buscar Alumno ---")
print("Buscar alumno:")
let buscar = readLine() ?? ""

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ==========================================
// TODO 3: Notas con clasificación
// ==========================================
print("\n--- TODO 3: Clasificación de Notas ---")
var notasClase: [Double] = []

for i in 1...5 {
    print("Nota del alumno \(i):")
    let n = Double(readLine() ?? "") ?? 0.0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota
    if nota >= 13.0 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

if !notasClase.isEmpty {
    let promClase = sumaNotas / Double(notasClase.count)
    print("Promedio: \(promClase)")
    print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")
}

// ==========================================
// FIX: Errores corregidos
// ==========================================
// FIX 1: Los arreglos de cadenas solo aceptan String
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva")
print("Frutas: \(frutas)")

// FIX 2: Se debe declarar con 'var' para poder modificar el arreglo
var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")
print("Colores: \(colores)")

// FIX 3: El índice 5 está fuera de rango, se usa 4
let numeros = [10, 20, 30, 40, 50]
print("Número en índice 4: \(numeros[4])")

// ==========================================
// PREDICT: Predicción de resultados
// ==========================================
var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)
print(lista)       // PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count) // PREDICT 2: 5

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted()) // PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres)          // PREDICT 4: ["Ana", "Carlos", "Beto"]

// ==========================================
// Ejercicio 2: Diccionarios
// ==========================================

// ==========================================
// TODO 4: Catálogo de productos
// ==========================================
print("\n--- TODO 4: Registro de Productos ---")
var productos: [String: Double] = [:]

for i in 1...4 {
    print("Producto \(i) Nombre:")
    let nombre = readLine() ?? ""
    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0.0
    productos[nombre] = precio
}

// ==========================================
// TODO 5: Mostrar catálogo
// ==========================================
print("\n--- TODO 5: Catálogo de Productos ---")
print("===== CATÁLOGO =====")
for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}

// ==========================================
// TODO 6: Valor total del catálogo
// ==========================================
print("\n--- TODO 6: Valor Total ---")
var valorTotal = 0.0
for (_, precio) in productos {
    valorTotal += precio
}
print("Valor total: S/. \(valorTotal)")

// ==========================================
// TODO 7: Buscar un producto
// ==========================================
print("\n--- TODO 7: Buscar Producto ---")
print("Buscar producto:")
let buscarProd = readLine() ?? ""

if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}

// ==========================================
// ANALYZE: Análisis de código
// ==========================================
print("\n--- ANALYZE ---")
var edades: [String: Int] = ["Ana": 20, "Luis": 22, "María": 19]
var mayores: [String] = []

for (nombre, edad) in edades {
    if edad >= 21 {
        mayores.append(nombre)
    }
}
print("Mayores de 21: \(mayores)")
// ANALYZE 1: Recorre el diccionario 'edades', evalúa cuáles tienen una edad mayor o igual a 21 (en este caso sólo "Luis": 22) y agrega sus nombres al arreglo 'mayores'. Imprime: Mayores de 21: ["Luis"]

// ==========================================
// Ejercicio 3: Sets
// ==========================================

// ==========================================
// TODO 8: Eliminar duplicados
// ==========================================
print("\n--- TODO 8: Eliminar Duplicados ---")
var numerosDuplicados: [Int] = []

for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    numerosDuplicados.append(n)
}

print("Con duplicados: \(numerosDuplicados)")
let sinDuplicados = Array(Set(numerosDuplicados)).sorted()
print("Sin duplicados: \(sinDuplicados)")

// ==========================================
// TODO 9: Comparar asistencia
// ==========================================
print("\n--- TODO 9: Comparar Asistencia ---")
var lunes: Set<String> = []
var martes: Set<String> = []

print("=== Asistencia Lunes ===")
for i in 1...4 {
    print("Alumno \(i) Lunes:")
    let nombre = readLine() ?? ""
    lunes.insert(nombre)
}

print("\n=== Asistencia Martes ===")
for i in 1...4 {
    print("Alumno \(i) Martes:")
    let nombre = readLine() ?? ""
    martes.insert(nombre)
}

print("\nAsistieron ambos días: \(lunes.intersection(martes))")
print("Solo asistieron lunes: \(lunes.subtracting(martes))")
print("Solo asistieron martes: \(martes.subtracting(lunes))")

// ==========================================
// PREDICT: Predicción de resultados
// ==========================================
let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b))       // PREDICT 5: [4, 5]
print(a.union(b).count)        // PREDICT 6: 8
print(a.subtracting(b))       // PREDICT 7: [1, 2, 3]

var repetidos: Set = ["A", "B", "A", "C", "B"]
print(repetidos.count)         // PREDICT 8: 3

// ==========================================
// Ejercicio 4: Combinación de Colecciones
// ==========================================

// ==========================================
// TODO 10: Inventario de productos
// ==========================================
print("\n--- TODO 10: Inventario de Productos ---")
var preciosInventario: [String: Double] = [:]
var stocksInventario: [String: Int] = [:]

print("¿Cuántos productos?")
let cantidadProd = Int(readLine() ?? "") ?? 0

for i in 1...cantidadProd {
    print("\nProducto \(i) Nombre:")
    let nombre = readLine() ?? ""
    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0.0
    print("Stock:")
    let stock = Int(readLine() ?? "") ?? 0
    
    preciosInventario[nombre] = precio
    stocksInventario[nombre] = stock
}

print("\n===== REPORTE DE INVENTARIO =====")
var valorTotalInventario = 0.0

for (nombre, precio) in preciosInventario {
    if let stock = stocksInventario[nombre] {
        let subtotalProducto = precio * Double(stock)
        valorTotalInventario += subtotalProducto
        print("\(nombre) -> Precio: S/. \(precio) | Stock: \(stock) | Subtotal: S/. \(subtotalProducto)")
    }
}

print("\nValor total del inventario: S/. \(valorTotalInventario)")

print("\n===== PRODUCTOS CON STOCK BAJO (< 5) =====")
var hayStockBajo = false
for (nombre, stock) in stocksInventario {
    if stock < 5 {
        if let precio = preciosInventario[nombre] {
            print("Alerta: \(nombre) tiene un stock crítico de \(stock) unidades (S/. \(precio) c/u)")
            hayStockBajo = true
        }
    }
}

if !hayStockBajo {
    print("Todos los productos tienen stock suficiente (>= 5).")
}

// ==========================================
// Ejercicio 5: Carrito de Compras 2.0
// ==========================================

// TODO 11: Arreglos para almacenar datos del carrito
var nombresCarrito: [String] = []
var preciosCarrito: [Double] = []
var cantidadesCarrito: [Int] = []

print("\n--- TODO 11-18: Carrito de Compras 2.0 ---")
print("¿Cuántos productos va a comprar?")
let totalProductos = Int(readLine() ?? "") ?? 0

for i in 1...totalProductos {
    print("\nProducto \(i) Nombre:")
    nombresCarrito.append(readLine() ?? "")
    
    print("Precio unitario:")
    preciosCarrito.append(Double(readLine() ?? "") ?? 0.0)
    
    print("Cantidad:")
    cantidadesCarrito.append(Int(readLine() ?? "") ?? 0)
}

// TODO 12: Calcular subtotales por producto
var subtotalesCarrito: [Double] = []
for i in 0..<nombresCarrito.count {
    let sub = preciosCarrito[i] * Double(cantidadesCarrito[i])
    subtotalesCarrito.append(sub)
}

// TODO 13: Total bruto del carrito
var totalCarrito = 0.0
for sub in subtotalesCarrito {
    totalCarrito += sub
}

// TODO 14: Nombre del cliente
print("\nNombre del cliente:")
let cliente = readLine() ?? ""

// TODO 15: Aplicar descuento según el total
var descPct = 0.0
if totalCarrito >= 5000 {
    descPct = 0.15
} else if totalCarrito >= 2000 {
    descPct = 0.10
} else if totalCarrito >= 500 {
    descPct = 0.05
}

let descuento = totalCarrito * descPct
let totalConDesc = totalCarrito - descuento

// TODO 16: IGV (18%) y total final
let igv = totalConDesc * 0.18
let totalFinal = totalConDesc + igv

// TODO 17: Categoría del cliente mediante switch
var categoria = ""
switch Int(totalCarrito) {
case 0..<500:
    categoria = "Regular"
case 500..<2000:
    categoria = "Frecuente"
case 2000..<5000:
    categoria = "VIP"
default:
    categoria = "Premium"
}

// TODO 18: Impresión del Ticket de Compra
let sep = String(repeating: "=", count: 45)
print("\n" + sep)
print("          TICKET DE COMPRA 2.0")
print(" Cliente: \(cliente) (\(categoria))")
print(sep)

for i in 0..<nombresCarrito.count {
    print("\(nombresCarrito[i]) x\(cantidadesCarrito[i]) S/. \(subtotalesCarrito[i])")
}

print(sep)
print("Subtotal:           S/. \(totalCarrito)")
if descPct > 0 {
    print("Descuento (\(descPct * 100)%): -S/. \(descuento)")
}
print("IGV (18%):          S/. \(igv)")
print(sep)
print("TOTAL:              S/. \(totalFinal)")
print(sep)
print("¡Gracias por su compra, \(cliente)!")


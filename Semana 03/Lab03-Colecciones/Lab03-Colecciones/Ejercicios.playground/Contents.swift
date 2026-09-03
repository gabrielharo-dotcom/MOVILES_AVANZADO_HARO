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

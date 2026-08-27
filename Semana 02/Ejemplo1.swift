import Foundation

let parcial = 0.3
let trabajo = 0.3
let final = 0.4

print("Nombre del alumno ")
let alumno = readLine()!

// commit del ingreso de datos
print("Nota parcial ")
let parcialNota = Double(readLine() ?? "") ?? 0

print("Nota Trabajo ")
let trabajoNota = Double(readLine() ?? "") ?? 0

print("Nota final ")
let finalNota = Double(readLine() ?? "") ?? 0

// commit del calculo
let promedioFinal = (parcialNota * parcial) + (trabajoNota * trabajo) + (finalNota * final)

// commit de mostrar los datos
print("Resultados del alumno")
print("Alumno: \(alumno)")
print("Promedio Final: \(promedioFinal)")

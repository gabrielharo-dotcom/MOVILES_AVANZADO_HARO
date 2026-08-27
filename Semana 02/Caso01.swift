import Foundation
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd/MM/yyyy"

//Primer commit: Ingreso de datos.
print("Título del libro:")
let tituloLibro = readLine() ?? ""

print("Tipo de Usuario (Alumno / Docente / Administrador):")
let tipoUsuario = (readLine() ?? "").capitalized

print("Fecha de Préstamo (dd/MM/yyyy):")
let fechaPrestamoStr = readLine() ?? ""

print("Fecha de Devolución Real (dd/MM/yyyy):")
let fechaDevolucionStr = readLine() ?? ""

//Segundo Commit: El cálculo con su multa progresiva.
var diasLimite = 7
var multaBaseDiaria = 1.5

if tipoUsuario == "Docente"{
    diasLimite = 15
    multaBaseDiaria = 2.0
} else if tipoUsuario == "Administrador"{
    diasLimite = 10
    multaBaseDiaria = 3.0
}

let fPrestamo = dateFormatter.date(from: fechaPrestamoStr) ?? Date()
let fDevolucion = dateFormatter.date(from: fechaDevolucionStr) ?? Date()

let componentes = Calendar.current.dateComponents([.day], from: fPrestamo, to: fDevolucion)
let diasExedidos = componentes.day ?? 0
let diasAtraso = max(0, diasExedidos - diasLimite)

var multaAcumulada = 0.0
for dia in 1...diasAtraso{
    var costoDia = multaBaseDiaria
    if dia >= 4 && dia <= 6{
        costoDia *= 1.5
    } else if dia > 7{
        costoDia *= 2.0
    }
    multaAcumulada += costoDia
}

//Tercer Commit: Resultados y estado del usuario respecto al préstamo
print("Libro: \(tituloLibro)")
print("Usuario: \(tipoUsuario)")
print("F. Préstamo: \(fechaPrestamoStr)")
print("F. Devolución: \(fechaDevolucionStr)")
print("Días de atraso: \(diasAtraso)")
print("Multa total acumulada: S/ \(String(format: "%.2f", multaAcumulada))")

if diasAtraso >= 10 {
print("ESTADO: ¡El usuario queda SUSPENDIDO de préstamos por acumular 10 o más días de atraso!")
} else {
print("ESTADO: Usuario habilitado.")
}

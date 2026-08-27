import Foundation

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd/MM/yyyy"

print("Título del libro:")
let tituloLibro = readLine() ?? ""

print("Tipo de Usuario (Alumno / Docente / Administrador):")
let tipoUsuario = (readLine() ?? "").capitalized

print("Fecha de Préstamo (dd/MM/yyyy):")
let fechaPrestamoStr = readLine() ?? ""

print("Fecha de Devolución (dd/MM/yyyy):")
let fechaDevolucionStr = readLine() ?? ""

var diasLimitePermitidos = 7
var multaBaseDiaria = 1.5

if tipoUsuario == "Docente" {
    diasLimitePermitidos = 15
    multaBaseDiaria = 2.0
} else if tipoUsuario == "Administrador" {
    diasLimitePermitidos = 10
    multaBaseDiaria = 3.0
}

guard let fPrestamo = dateFormatter.date(from: fechaPrestamoStr),
      let fDevolucion = dateFormatter.date(from: fechaDevolucionStr) else {
    print("Error: Formato de fecha incorrecto. Use el formato dd/MM/yyyy.")
    exit(0)
}

if fDevolucion < fPrestamo {
    print("Error: La fecha de devolución no puede ser anterior a la fecha de préstamo.")
    exit(0)
}

let componentesSolicitados = Calendar.current.dateComponents([.day], from: fPrestamo, to: fDevolucion)
let diasSolicitados = componentesSolicitados.day ?? 0

if diasSolicitados > diasLimitePermitidos {
    print("\nPRÉSTAMO RECHAZADO: Como \(tipoUsuario), el límite máximo es de \(diasLimitePermitidos) días.")
    print("Has solicitado \(diasSolicitados) días. El sistema no permite plazos tan grandes y el calendario de pago sería inviable.")
    exit(0)
}

let fechaLimitePermitida = Calendar.current.date(byAdding: .day, value: diasLimitePermitidos, to: fPrestamo) ?? fPrestamo

let componentesAtraso = Calendar.current.dateComponents([.day], from: fechaLimitePermitida, to: fDevolucion)
let diasAtraso = max(0, componentesAtraso.day ?? 0)

var multaAcumulada = 0.0

print("CALENDARIO DE PAGO / MULTA ---")
if diasAtraso > 0 {
    print("Día | Fecha estimada | Multa del día | Acumulado")
    print("-------------------------------------------------")
    
    for dia in 1...diasAtraso {
        var costoDia = multaBaseDiaria
        if dia >= 4 && dia <= 6 {
            costoDia *= 1.5
        } else if dia >= 7 {
            costoDia *= 2.0
        }
        multaAcumulada += costoDia
        
        let fechaDiaAtraso = Calendar.current.date(byAdding: .day, value: dia, to: fechaLimitePermitida) ?? fechaLimitePermitida
        let fechaStr = dateFormatter.string(from: fechaDiaAtraso)
        
        print("  \(dia) |    \(fechaStr)   |    S/ \(String(format: "%.2f", costoDia))   |  S/ \(String(format: "%.2f", multaAcumulada))")
    }
} else {
    print("No hay días de atraso. El libro se devolvió a tiempo.")
}

print("RESULTADOS FINALES ---")
print("Libro: \(tituloLibro)")
print("Usuario: \(tipoUsuario)")
print("F. Préstamo: \(fechaPrestamoStr)")
print("F. Devolución: \(fechaDevolucionStr)")
print("Días de atraso: \(diasAtraso)")
print("Multa total a pagar: S/ \(String(format: "%.2f", multaAcumulada))")

if diasAtraso >= 10 {
    print("ESTADO: ¡El usuario queda SUSPENDIDO de los préstamos por acumular 10 o más días de atraso!")
} else {
    print("ESTADO: Usuario habilitado o devolución procesada correctamente.")
}

import Foundation

let diasAlumno = 7
let diasDocente = 15
let diasAdministrador = 10


let multaAlumno = 1.50
let multaDocente = 2.00
let multaAdministrador = 3.00


// MARK: - INGRESO DE DATOS
print("SISTEMA DE PRÉSTAMO DE LIBROS")

print("")
print("Título del libro:")
let tituloLibro = readLine() ?? ""


// MARK: - SELECCIONAR TIPO DE USUARIO

var tipoUsuario = ""
var diasPermitidos = 0
var multaPorDia = 0.0


while true {

    print("")
    print("Tipo de usuario:")
    print("1. Alumno")
    print("2. Docente")
    print("3. Administrador")

    print("")
    print("Ingrese el tipo de usuario:")

    tipoUsuario = readLine() ?? ""


    switch tipoUsuario.lowercased() {

    case "alumno":

        diasPermitidos = diasAlumno
        multaPorDia = multaAlumno
        tipoUsuario = "Alumno"

    case "docente":

        diasPermitidos = diasDocente
        multaPorDia = multaDocente
        tipoUsuario = "Docente"

    case "administrador":

        diasPermitidos = diasAdministrador
        multaPorDia = multaAdministrador
        tipoUsuario = "Administrador"

    default:

        print("")
        print("❌ ERROR: Tipo de usuario no válido.")
        print("Ingrese Alumno, Docente o Administrador.")

        continue
    }

    break
}

// MARK: - CONFIGURACIÓN DEL CALENDARIO

let calendario = Calendar.current

let formatoFecha = DateFormatter()

formatoFecha.dateFormat = "dd/MM/yyyy"
formatoFecha.locale = Locale(identifier: "es_PE")
formatoFecha.calendar = calendario


// MARK: - VARIABLES DE FECHAS

var fechaPrestamo = Date()
var fechaPrometida = Date()

var fechaPrestamoTexto = ""
var fechaPrometidaTexto = ""

var diasSolicitados = 0


// MARK: - INGRESO Y VALIDACIÓN DEL PRÉSTAMO

while true {
    
    print("DATOS DEL PRÉSTAMO")
    print("")
    print("Fecha de préstamo (dd/MM/yyyy):")
    
    fechaPrestamoTexto = readLine() ?? ""
    
    
    // Validar fecha de préstamo
    
    guard let fechaPrestamoIngresada =
            formatoFecha.date(from: fechaPrestamoTexto) else {
        
        print("")
        print("FECHA DE PRÉSTAMO NO VÁLIDA.")
        print("Utiliza el formato dd/MM/yyyy.")
        
        continue
    }
    
    fechaPrestamo = fechaPrestamoIngresada
    
    
    // Fecha prometida
    
    print("")
    print("Fecha prometida de devolución (dd/MM/yyyy):")
    
    fechaPrometidaTexto = readLine() ?? ""
    
    
    // Validar fecha prometida
    
    guard let fechaPrometidaIngresada =
            formatoFecha.date(from: fechaPrometidaTexto) else {
        
        print("")
        print("FECHA PROMETIDA NO VÁLIDA.")
        print("Utiliza el formato dd/MM/yyyy.")
        
        continue
    }
    
    fechaPrometida = fechaPrometidaIngresada
    
    
    // Validar orden de fechas
    
    if fechaPrometida < fechaPrestamo {
        
        print("")
        print("ERROR")
        print("La fecha prometida no puede ser anterior")
        print("a la fecha de préstamo.")
        
        continue
    }
    
    
    // Calcular días solicitados

    let componentesPrestamo = calendario.dateComponents(
        [.day],
        from: fechaPrestamo,
        to: fechaPrometida
    )

    diasSolicitados = componentesPrestamo.day ?? 0


    // Validar máximo permitido

    if diasSolicitados > diasPermitidos {

        print("")
        print("PRÉSTAMO NO PERMITIDO")

        print("")
        print("Usuario: \(tipoUsuario)")
        print("Días máximos permitidos: \(diasPermitidos)")
        print("Días solicitados: \(diasSolicitados)")

        print("")
        print("NO SE PUEDE REALIZAR EL PRÉSTAMO.")
        print("El usuario supera el máximo de días permitido.")

        print("")
        print("Ingrese nuevamente las fechas.")


        continue
    }


    // Préstamo permitido

    print("")
    print("PRÉSTAMO PERMITIDO")

    print("Usuario: \(tipoUsuario)")
    print("Días máximos permitidos: \(diasPermitidos)")
    print("Días solicitados: \(diasSolicitados)")


    break
}


// MARK: - FECHA REAL DE DEVOLUCIÓN

var fechaDevolucion = Date()
var fechaDevolucionTexto = ""

while true {

    print("")
    print("Fecha real de devolución (dd/MM/yyyy):")

    fechaDevolucionTexto = readLine() ?? ""


    guard let fechaDevolucionIngresada =
            formatoFecha.date(from: fechaDevolucionTexto) else {

        print("")
        print("FECHA DE DEVOLUCIÓN NO VÁLIDA.")
        print("Utiliza el formato dd/MM/yyyy.")

        continue
    }

    fechaDevolucion = fechaDevolucionIngresada


    if fechaDevolucion < fechaPrestamo {

        print("")
        print("ERROR")
        print("La fecha real de devolución no puede ser")
        print("anterior a la fecha de préstamo.")

        continue
    }

    break
}


// MARK: - CALCULAR DÍAS DE ATRASO

let componentesAtraso = calendario.dateComponents(
    [.day],
    from: fechaPrometida,
    to: fechaDevolucion
)

let diasAtraso = max(
    0,
    componentesAtraso.day ?? 0
)


// MARK: - CALCULAR MULTA PROGRESIVA

var multaTotal = 0.0

if diasAtraso > 0 {

    for dia in 1...diasAtraso {

        if dia <= 3 {

            // Día 1 al 3
            // 100%

            multaTotal += multaPorDia

        } else if dia <= 6 {

            // Día 4 al 6
            // 150%

            multaTotal += multaPorDia * 1.50

        } else {

            // Día 7 en adelante
            // 200%

            multaTotal += multaPorDia * 2.00
        }
    }
}


// MARK: - ESTADO DEL PRÉSTAMO

var estadoPrestamo = ""

if diasAtraso == 0 {

    estadoPrestamo = "Devuelto a tiempo"

} else {

    estadoPrestamo = "Devuelto con atraso"
}


// MARK: - SITUACIÓN DEL USUARIO

var situacionUsuario = ""

// Solo el docente puede quedar suspendido

if tipoUsuario == "Docente" && diasAtraso >= 10 {

    situacionUsuario = "Suspendido"

} else {

    situacionUsuario = "Habilitado"
}


// MARK: - CALENDARIO DE ATRASO

if diasAtraso > 0 {

    print("")
    print("==============================================================")
    print("                  CALENDARIO DE ATRASO")
    print("==============================================================")

    print("Fecha        Atraso       Multa día       Acumulado")
    print("--------------------------------------------------------------")

    var multaAcumulada = 0.0


    for dia in 1...diasAtraso {

        let fechaAtraso = calendario.date(
            byAdding: .day,
            value: dia,
            to: fechaPrometida
        )!


        let fechaTexto = formatoFecha.string(
            from: fechaAtraso
        )


        var multaDia = 0.0
        var porcentaje = ""


        if dia <= 3 {

            multaDia = multaPorDia
            porcentaje = "100%"

        } else if dia <= 6 {

            multaDia = multaPorDia * 1.50
            porcentaje = "150%"

        } else {

            multaDia = multaPorDia * 2.00
            porcentaje = "200%"
        }


        multaAcumulada += multaDia

        
        print(
            "\(fechaTexto)    " +
            "\(String(format: "%2d", dia))           " +
            "S/ \(String(format: "%.2f", multaDia))    " +
            "S/ \(String(format: "%.2f", multaAcumulada))"
        )

        print(
            "             Multa aplicada: \(porcentaje)"
        )
    }

    print("==============================================================")

} else {

    print("")
    print("==============================================================")
    print("              NO EXISTEN DÍAS DE ATRASO")
    print("==============================================================")
}
// MARK: - RESUMEN FINAL

print("")
print("================================================")
print("              RESUMEN DEL PRÉSTAMO")
print("================================================")

print("Libro: \(tituloLibro)")
print("Tipo de usuario: \(tipoUsuario)")

print("-----------------------------------------------")

print("Fecha de préstamo: \(fechaPrestamoTexto)")
print("Fecha prometida: \(fechaPrometidaTexto)")
print("Fecha real de devolución: \(fechaDevolucionTexto)")

print("-----------------------------------------------")

print("Días máximos permitidos: \(diasPermitidos)")
print("Días solicitados: \(diasSolicitados)")
print("Días de atraso: \(diasAtraso)")

print("-----------------------------------------------")

print(
    "Multa normal por día: S/ " +
    String(format: "%.2f", multaPorDia)
)

print(
    "Multa acumulada: S/ " +
    String(format: "%.2f", multaTotal)
)

print("-----------------------------------------------")

print("Estado del préstamo: \(estadoPrestamo)")
print("Situación del usuario: \(situacionUsuario)")

print("================================================")


// MARK: - MENSAJE DE SUSPENSIÓN

if tipoUsuario == "Docente" && diasAtraso >= 10 {

    print("")
    print("=============================================")
    print("              USUARIO SUSPENDIDO")
    print("=============================================")
    print("El docente alcanzó \(diasAtraso)")
    print("días de atraso.")
    print("=============================================")
}

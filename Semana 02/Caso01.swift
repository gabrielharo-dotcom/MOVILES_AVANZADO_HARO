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

import Foundation

struct ErrorValidacion: Error {
    let mensaje: String
}

// Lo que escribió el usuario, tal cual (texto). validar() lo convierte en DatosBoleta.
struct FormularioBoleta {
    var sueldo: String
    var dias: String
    var tieneHijos: Bool
    var sistema: SistemaPension
    var afp: String
    var horasExtras25: String
    var horasExtras35: String
    var adelantos: String

    func validar() -> Result<DatosBoleta, ErrorValidacion> {
        guard let sueldoBasico = numero(sueldo), sueldoBasico > 0 else {
            return .failure(ErrorValidacion(mensaje: "El sueldo básico debe ser un número mayor que cero."))
        }
        guard let diasLaborados = Int(dias.trimmingCharacters(in: .whitespaces)),
              (1...30).contains(diasLaborados) else {
            return .failure(ErrorValidacion(mensaje: "Los días laborados deben ser un número entero entre 1 y 30."))
        }
        // Los campos opcionales vacíos cuentan como 0.
        guard let h25 = numeroOpcional(horasExtras25), h25 >= 0 else {
            return .failure(ErrorValidacion(mensaje: "Las horas extras al 25% deben ser un número mayor o igual a cero."))
        }
        guard let h35 = numeroOpcional(horasExtras35), h35 >= 0 else {
            return .failure(ErrorValidacion(mensaje: "Las horas extras al 35% deben ser un número mayor o igual a cero."))
        }
        guard let adelantosMonto = numeroOpcional(adelantos), adelantosMonto >= 0 else {
            return .failure(ErrorValidacion(mensaje: "Los adelantos deben ser un número mayor o igual a cero."))
        }
        if sistema == .afp && Parametros.tasasAFP[afp] == nil {
            return .failure(ErrorValidacion(mensaje: "Elige una AFP de la lista."))
        }

        guard adelantosMonto == adelantosMonto.redondeado() else {
            return .failure(ErrorValidacion(mensaje: "Los adelantos admiten como máximo dos decimales."))
        }
        return .success(DatosBoleta(
            sueldoBasico: sueldoBasico,
            diasLaborados: diasLaborados,
            tieneHijos: tieneHijos,
            sistema: sistema,
            nombreAFP: afp,
            horasExtras25: h25,
            horasExtras35: h35,
            adelantos: adelantosMonto
        ))
    }

    // Solo dígitos y un punto (acepta coma como punto). Devuelve nil si hay otra cosa.
    // Decimal(string:) por sí solo aceptaría "12abc" como 12, por eso se revisa antes.
    private func numero(_ texto: String) -> Decimal? {
        let limpio = texto.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")
        let soloNumero = !limpio.isEmpty
            && limpio.allSatisfy { $0.isASCII && ($0.isNumber || $0 == ".") }
            && limpio.filter({ $0 == "." }).count <= 1
        return soloNumero ? Decimal(string: limpio) : nil
    }

    private func numeroOpcional(_ texto: String) -> Decimal? {
        texto.trimmingCharacters(in: .whitespaces).isEmpty ? 0 : numero(texto)
    }
}

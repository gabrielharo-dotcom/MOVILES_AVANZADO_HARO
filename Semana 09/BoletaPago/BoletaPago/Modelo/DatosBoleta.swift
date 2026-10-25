import Foundation

enum SistemaPension: String, CaseIterable {
    case onp = "ONP"
    case afp = "AFP"
}

// Datos del mes que ingresa el usuario (ya validados).
struct DatosBoleta {
    var sueldoBasico: Decimal
    var diasLaborados: Int
    var tieneHijos: Bool
    var sistema: SistemaPension
    var nombreAFP: String
    var horasExtras25: Decimal
    var horasExtras35: Decimal
    var adelantos: Decimal
}

// Una fila de la boleta: nombre y monto.
struct Concepto: Identifiable {
    let id = UUID()
    let nombre: String
    let monto: Decimal
}

extension Decimal {
    // Cada concepto se redondea a 2 decimales (media hacia arriba) y luego se suman.
    func redondeado() -> Decimal {
        var origen = self
        var resultado = Decimal()
        NSDecimalRound(&resultado, &origen, 2, .plain)
        return resultado
    }

    // 2,500.00 (separador de miles con coma y 2 decimales).
    func formatoSoles() -> String {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "en_US")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        return formato.string(from: self as NSDecimalNumber) ?? "0.00"
    }
}

import Foundation

// Tasas de una AFP: tres descuentos sobre el total de remuneraciones.
struct TasasAFP {
    let fondo: Decimal
    let comision: Decimal
    let seguro: Decimal
}

// Parámetros en un solo lugar (no se escriben dentro de las fórmulas).
// Fuentes y fecha de consulta: ver la tabla de fuentes en el README y en el Excel.
enum Parametros {
    // Se crean desde texto para que 0.13 sea exacto (un literal Double no lo es).
    static let rmv = Decimal(string: "1230")!                       // RMV vigente desde 01/10/2026 (por verificar)
    static let porcentajeAsignacionFamiliar = Decimal(string: "0.10")!  // Ley 25129
    static let tasaONP = Decimal(string: "0.13")!                   // D.L. 19990
    static let tasaEsSalud = Decimal(string: "0.09")!               // Ley 26790
    static let recargoHorasExtras25 = Decimal(string: "1.25")!
    static let recargoHorasExtras35 = Decimal(string: "1.35")!

    // Diccionario: nombre de la AFP -> sus tasas.
    // "AFP Ejemplo" es solo para los casos de prueba; para datos reales
    // agregar las AFP con los valores publicados por la SBS.
    static let tasasAFP: [String: TasasAFP] = [
        "AFP Ejemplo": TasasAFP(
            fondo: Decimal(string: "0.10")!,
            comision: Decimal(string: "0.016")!,
            seguro: Decimal(string: "0.0135")!
        )
    ]

    static var nombresAFP: [String] {
        tasasAFP.keys.sorted()
    }
}

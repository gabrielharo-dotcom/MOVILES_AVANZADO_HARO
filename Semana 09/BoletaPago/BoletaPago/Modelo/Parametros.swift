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
    // "AFP Ejemplo" es solo para los casos de prueba de la guía.
    // Las AFP reales: aporte obligatorio 10%, prima de seguro 1.37% y comisión
    // sobre flujo de cada AFP (SBS, devengue octubre 2026; ver tabla de fuentes).
    static let tasasAFP: [String: TasasAFP] = [
        "AFP Ejemplo": tasas(fondo: "0.10", comision: "0.016", seguro: "0.0135"),
        "Habitat": tasas(fondo: "0.10", comision: "0.0147", seguro: "0.0137"),
        "Integra": tasas(fondo: "0.10", comision: "0.0155", seguro: "0.0137"),
        "Prima": tasas(fondo: "0.10", comision: "0.0160", seguro: "0.0137"),
        "Profuturo": tasas(fondo: "0.10", comision: "0.0169", seguro: "0.0137")
    ]

    private static func tasas(fondo: String, comision: String, seguro: String) -> TasasAFP {
        TasasAFP(
            fondo: Decimal(string: fondo)!,
            comision: Decimal(string: comision)!,
            seguro: Decimal(string: seguro)!
        )
    }

    static var nombresAFP: [String] {
        tasasAFP.keys.sorted()
    }
}

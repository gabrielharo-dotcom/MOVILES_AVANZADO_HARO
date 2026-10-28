import Foundation
import XCTest
@testable import BoletaModelo

final class BoletaModeloTests: XCTestCase {
    private func decimal(_ texto: String) -> Decimal { Decimal(string: texto)! }

    private func calcular(sueldo: Decimal, dias: Int, hijos: Bool, sistema: SistemaPension,
                          h25: Decimal = 0, h35: Decimal = 0, adelantos: Decimal = 0,
                          afp: String = "AFP Ejemplo") -> Boleta {
        let boleta = Boleta(datos: DatosBoleta(
            sueldoBasico: sueldo, diasLaborados: dias, tieneHijos: hijos,
            sistema: sistema, nombreAFP: afp, horasExtras25: h25,
            horasExtras35: h35, adelantos: adelantos))
        boleta.calcular()
        return boleta
    }

    func testCaso1() {
        let b = calcular(sueldo: 2500, dias: 30, hijos: false, sistema: .onp)
        XCTAssertEqual(b.remuneraciones.map(\.monto), [2500, 0, 0, 0])
        XCTAssertEqual(b.descuentos.map(\.monto), [325, 0, 0, 0, 0])
        XCTAssertEqual(b.netoAPagar, 2175)
        XCTAssertEqual(b.aportaciones[0].monto, 225)
    }

    func testCaso2() {
        let b = calcular(sueldo: 1800, dias: 27, hijos: true, sistema: .onp)
        XCTAssertEqual(b.totalRemuneraciones, 1743)
        XCTAssertEqual(b.descuentos[0].monto, decimal("226.59"))
        XCTAssertEqual(b.netoAPagar, decimal("1516.41"))
        XCTAssertEqual(b.aportaciones[0].monto, decimal("156.87"))
    }

    func testCaso3() {
        let b = calcular(sueldo: 3000, dias: 30, hijos: true, sistema: .afp, h25: 4, h35: 4, adelantos: 200)
        XCTAssertEqual(b.remuneraciones.map(\.monto), [3000, 123, decimal("62.50"), decimal("67.50")])
        XCTAssertEqual(b.descuentos.map(\.monto), [0, decimal("325.30"), decimal("52.05"), decimal("43.92"), 200])
        XCTAssertEqual(b.totalDescuentos, decimal("621.27"))
        XCTAssertEqual(b.netoAPagar, decimal("2631.73"))
        XCTAssertEqual(b.aportaciones[0].monto, decimal("292.77"))
    }

    func testCaso4() {
        let b = calcular(sueldo: 4200, dias: 24, hijos: true, sistema: .afp, h25: 2, h35: 2, adelantos: 100)
        XCTAssertEqual(b.remuneraciones.map(\.monto), [3360, 123, decimal("43.75"), decimal("47.25")])
        XCTAssertEqual(b.descuentos.map(\.monto), [0, decimal("357.40"), decimal("57.18"), decimal("48.25"), 100])
        XCTAssertEqual(b.totalRemuneraciones, 3574)
        XCTAssertEqual(b.totalDescuentos, decimal("562.83"))
        XCTAssertEqual(b.netoAPagar, decimal("3011.17"))
        XCTAssertEqual(b.aportaciones[0].monto, decimal("321.66"))
    }

    func testAnalisisGrupal() {
        let onp = calcular(sueldo: 3000, dias: 30, hijos: true, sistema: .onp, h25: 4, h35: 4, adelantos: 200)
        XCTAssertEqual(onp.netoAPagar, decimal("2630.11"))
        let mesCompleto = calcular(sueldo: 1800, dias: 30, hijos: true, sistema: .onp)
        XCTAssertEqual(mesCompleto.netoAPagar, decimal("1673.01"))
    }

    func testExportarResultadosParaControlCruzado() throws {
        guard let ruta = ProcessInfo.processInfo.environment["BOLETA_RESULTADOS"] else { return }
        let casos = [
            calcular(sueldo: 2500, dias: 30, hijos: false, sistema: .onp),
            calcular(sueldo: 1800, dias: 27, hijos: true, sistema: .onp),
            calcular(sueldo: 3000, dias: 30, hijos: true, sistema: .afp, h25: 4, h35: 4, adelantos: 200),
            calcular(sueldo: 4200, dias: 24, hijos: true, sistema: .afp, h25: 2, h35: 2, adelantos: 100)
        ]
        let resultados = casos.enumerated().map { indice, boleta -> [String: String] in
            var fila = ["caso": String(indice + 1)]
            for concepto in boleta.remuneraciones + boleta.descuentos + boleta.aportaciones {
                fila[concepto.nombre] = NSDecimalNumber(decimal: concepto.monto).stringValue
            }
            fila["Total remuneraciones"] = NSDecimalNumber(decimal: boleta.totalRemuneraciones).stringValue
            fila["Total descuentos"] = NSDecimalNumber(decimal: boleta.totalDescuentos).stringValue
            fila["Neto a pagar"] = NSDecimalNumber(decimal: boleta.netoAPagar).stringValue
            return fila
        }
        let json = try JSONSerialization.data(withJSONObject: resultados, options: [.prettyPrinted, .sortedKeys])
        try json.write(to: URL(fileURLWithPath: ruta))
        XCTAssertEqual(resultados.count, 4)
    }

    func testTasasRealesYCalculoRepetido() {
        let b = calcular(sueldo: 3000, dias: 30, hijos: true, sistema: .afp, h25: 4, h35: 4, adelantos: 200, afp: "Habitat")
        XCTAssertEqual(b.descuentos[2].monto, decimal("47.82"))
        XCTAssertEqual(b.descuentos[3].monto, decimal("44.57"))
        let neto = b.netoAPagar
        b.calcular()
        XCTAssertEqual(b.netoAPagar, neto)
        XCTAssertEqual(b.remuneraciones.count, 4)
        XCTAssertEqual(b.descuentos.count, 5)
    }

    func testValidacionesYComaDecimal() {
        var f = FormularioBoleta(sueldo: "1800,50", dias: "30", tieneHijos: false,
            sistema: .onp, afp: "AFP Ejemplo", horasExtras25: "", horasExtras35: "", adelantos: "")
        guard case .success(let datos) = f.validar() else { return XCTFail("Debe aceptar coma decimal y opcionales vacíos") }
        XCTAssertEqual(datos.sueldoBasico, decimal("1800.50"))
        for sueldo in ["", "0", "-1", "12abc", "1.2.3", "."] {
            f.sueldo = sueldo
            if case .success = f.validar() { XCTFail("Aceptó sueldo inválido: \(sueldo)") }
        }
        f.sueldo = "1800"
        for dias in ["0", "31", "2.5", ""] {
            f.dias = dias
            if case .success = f.validar() { XCTFail("Aceptó días inválidos: \(dias)") }
        }
        f.dias = "30"
        f.horasExtras25 = "-1"
        if case .success = f.validar() { XCTFail("Aceptó horas negativas") }
        f.horasExtras25 = "0"
        f.horasExtras35 = "-1"
        if case .success = f.validar() { XCTFail("Aceptó horas negativas") }
        f.horasExtras35 = "0"
        for adelanto in ["-1", "1.005", "abc"] {
            f.adelantos = adelanto
            if case .success = f.validar() { XCTFail("Aceptó adelanto inválido") }
        }
        f.adelantos = "0"
        f.sistema = .afp
        f.afp = "Desconocida"
        if case .success = f.validar() { XCTFail("Aceptó AFP desconocida") }
    }
}

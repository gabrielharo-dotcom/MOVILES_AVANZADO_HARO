import Foundation

// Descuentos, aportación del empleador y neto a pagar.
extension Boleta {

    func calcular() {
        calcularRemuneraciones()
        calcularDescuentos()
    }

    func calcularDescuentos() {
        let base = totalRemuneraciones

        var onp: Decimal = 0
        var fondo: Decimal = 0
        var comision: Decimal = 0
        var seguro: Decimal = 0

        switch datos.sistema {
        case .onp:
            onp = (base * Parametros.tasaONP).redondeado()
        case .afp:
            if let tasas = Parametros.tasasAFP[datos.nombreAFP] {
                fondo = (base * tasas.fondo).redondeado()
                comision = (base * tasas.comision).redondeado()
                seguro = (base * tasas.seguro).redondeado()
            }
        }

        // Los conceptos que no aplican se muestran con 0.00, como en la boleta real.
        descuentos = [
            Concepto(nombre: "ONP", monto: onp),
            Concepto(nombre: "AFP fondo", monto: fondo),
            Concepto(nombre: "AFP comisión", monto: comision),
            Concepto(nombre: "AFP seguro", monto: seguro),
            Concepto(nombre: "Adelantos", monto: datos.adelantos)
        ]
        totalDescuentos = descuentos.reduce(0) { $0 + $1.monto }

        // EsSalud lo paga el empleador: no se descuenta al trabajador.
        let esSalud = (base * Parametros.tasaEsSalud).redondeado()
        aportaciones = [Concepto(nombre: "EsSalud (9%)", monto: esSalud)]
    }

    var netoAPagar: Decimal {
        totalRemuneraciones - totalDescuentos
    }
}

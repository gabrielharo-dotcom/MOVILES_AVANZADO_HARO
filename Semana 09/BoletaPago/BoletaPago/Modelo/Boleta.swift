import Foundation

// Calcula la boleta. No sabe nada de la pantalla.
// Esta parte: remuneraciones. Los descuentos y el neto están en Boleta+Descuentos.swift.
final class Boleta {
    let datos: DatosBoleta

    // Array con los conceptos de remuneraciones.
    var remuneraciones: [Concepto] = []
    var totalRemuneraciones: Decimal = 0

    // Se llenan en Boleta+Descuentos.swift (una extensión no puede guardar propiedades).
    var descuentos: [Concepto] = []
    var totalDescuentos: Decimal = 0
    var aportaciones: [Concepto] = []

    init(datos: DatosBoleta) {
        self.datos = datos
    }

    // Valor hora = sueldo básico ÷ 30 ÷ 8.
    // Se multiplica antes de dividir para no arrastrar decimales de más.

    func calcularRemuneraciones() {
        let sueldo = datos.sueldoBasico

        // Sueldo básico ÷ 30 × días laborados
        let sueldoComputable = (sueldo * Decimal(datos.diasLaborados) / 30).redondeado()

        // 10% de la RMV si tiene hijos; no se prorratea por días
        let asignacionFamiliar = datos.tieneHijos
            ? (Parametros.rmv * Parametros.porcentajeAsignacionFamiliar).redondeado()
            : 0

        // Valor hora × recargo × horas  =  sueldo ÷ 240 × recargo × horas
        let horasExtras25 = (sueldo * Parametros.recargoHorasExtras25 * datos.horasExtras25 / 240).redondeado()
        let horasExtras35 = (sueldo * Parametros.recargoHorasExtras35 * datos.horasExtras35 / 240).redondeado()

        remuneraciones = [
            Concepto(nombre: "Sueldo computable", monto: sueldoComputable),
            Concepto(nombre: "Asignación familiar", monto: asignacionFamiliar),
            Concepto(nombre: "Horas extras 25%", monto: horasExtras25),
            Concepto(nombre: "Horas extras 35%", monto: horasExtras35)
        ]
        totalRemuneraciones = remuneraciones.reduce(0) { $0 + $1.monto }
    }
}

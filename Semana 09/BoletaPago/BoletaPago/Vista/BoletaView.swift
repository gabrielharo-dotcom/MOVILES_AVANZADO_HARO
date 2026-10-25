import SwiftUI

// Muestra la boleta en tres bloques, uno debajo del otro (formato celular).
struct BoletaView: View {
    let boleta: Boleta

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Boleta de ejemplo")
                .font(.title2)
                .bold()

            bloque(
                titulo: "REMUNERACIONES",
                conceptos: boleta.remuneraciones,
                totalNombre: "Total remuneraciones",
                total: boleta.totalRemuneraciones
            )
            bloque(
                titulo: "RETENCIONES / DESCUENTOS",
                conceptos: boleta.descuentos,
                totalNombre: "Total descuentos",
                total: boleta.totalDescuentos
            )
            bloque(
                titulo: "APORTACIONES DEL EMPLEADOR",
                conceptos: boleta.aportaciones,
                totalNombre: nil,
                total: nil
            )

            Text("NETO A PAGAR: S/ \(boleta.netoAPagar.formatoSoles())")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.accentColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func bloque(titulo: String, conceptos: [Concepto], totalNombre: String?, total: Decimal?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.headline)

            ForEach(conceptos) { concepto in
                fila(nombre: concepto.nombre, monto: concepto.monto, enNegrita: false)
            }

            if let totalNombre = totalNombre, let total = total {
                fila(nombre: totalNombre, monto: total, enNegrita: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func fila(nombre: String, monto: Decimal, enNegrita: Bool) -> some View {
        HStack {
            Text(nombre)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(monto.formatoSoles())
                .monospacedDigit()
        }
        .fontWeight(enNegrita ? .bold : .regular)
    }
}

extension BoletaView {
    // Caso 3 de la guía, solo para las previews.
    static func ejemploCaso3() -> Boleta {
        let datos = DatosBoleta(
            sueldoBasico: 3000, diasLaborados: 30, tieneHijos: true,
            sistema: .afp, nombreAFP: "AFP Ejemplo",
            horasExtras25: 4, horasExtras35: 4, adelantos: 200
        )
        let boleta = Boleta(datos: datos)
        boleta.calcular()
        return boleta
    }
}

#Preview("Caso 3") {
    BoletaView(boleta: BoletaView.ejemploCaso3())
        .padding()
}

#Preview("Caso 3 - oscuro, texto grande") {
    BoletaView(boleta: BoletaView.ejemploCaso3())
        .padding()
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.xxxLarge)
}

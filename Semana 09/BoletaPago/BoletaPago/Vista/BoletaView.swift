import SwiftUI

// Muestra la boleta: resumen del neto arriba y los tres bloques uno debajo del otro.
struct BoletaView: View {
    let boleta: Boleta

    var body: some View {
        VStack(spacing: Estilo.espacio) {
            resumenNeto

            bloque(
                titulo: "REMUNERACIONES",
                acento: Estilo.acentoRemuneraciones,
                conceptos: boleta.remuneraciones,
                totalNombre: "Total remuneraciones",
                total: boleta.totalRemuneraciones
            )
            bloque(
                titulo: "RETENCIONES / DESCUENTOS",
                acento: Estilo.acentoDescuentos,
                conceptos: boleta.descuentos,
                totalNombre: "Total descuentos",
                total: boleta.totalDescuentos
            )
            bloque(
                titulo: "APORTACIONES DEL EMPLEADOR",
                acento: Estilo.acentoEmpleador,
                conceptos: boleta.aportaciones,
                totalNombre: nil,
                total: nil
            )
        }
    }

    // Tarjeta destacada con el neto a pagar y qué parte del bruto llega al trabajador.
    private var resumenNeto: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("BOLETA DE EJEMPLO · NETO A PAGAR")
                .font(.caption)
                .fontWeight(.semibold)
                .tracking(0.8)
                .opacity(0.85)

            Text("S/ \(boleta.netoAPagar.formatoSoles())")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(textoPorcentaje)
                .font(.footnote)
                .opacity(0.9)
        }
        .foregroundStyle(.white)
        .padding(Estilo.espacio * 1.25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Estilo.degradado)
        .clipShape(RoundedRectangle(cornerRadius: Estilo.radio, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private var textoPorcentaje: String {
        guard boleta.totalRemuneraciones > 0 else {
            return "Sin remuneraciones en el mes."
        }
        let fraccion = boleta.netoAPagar / boleta.totalRemuneraciones
        return "Llega a tu bolsillo el \(fraccion.formatoPorcentaje(decimales: 1)) de tus remuneraciones."
    }

    private func bloque(titulo: String, acento: Color, conceptos: [Concepto], totalNombre: String?, total: Decimal?) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(acento)
                    .frame(width: 4, height: 18)
                Text(titulo)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .tracking(0.8)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)

            ForEach(conceptos) { concepto in
                fila(nombre: concepto.nombre, monto: concepto.monto, enNegrita: false)
            }

            if let totalNombre = totalNombre, let total = total {
                Rectangle()
                    .fill(Color.secondary.opacity(0.25))
                    .frame(height: 1)
                fila(nombre: totalNombre, monto: total, enNegrita: true)
            }
        }
        .tarjeta()
    }

    // Los conceptos que no aplican se muestran con 0.00 y más tenues, como en la boleta real.
    private func fila(nombre: String, monto: Decimal, enNegrita: Bool) -> some View {
        HStack {
            Text(nombre)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(monto.formatoSoles())
                .monospacedDigit()
        }
        .fontWeight(enNegrita ? .bold : .regular)
        .foregroundStyle(monto == 0 && !enNegrita ? Color.secondary : Color.primary)
        .accessibilityElement(children: .combine)
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
    ScrollView {
        BoletaView(boleta: BoletaView.ejemploCaso3())
            .padding()
    }
    .background(Estilo.fondoPantalla)
}

#Preview("Caso 3 - oscuro, texto grande") {
    ScrollView {
        BoletaView(boleta: BoletaView.ejemploCaso3())
            .padding()
    }
    .background(Estilo.fondoPantalla)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.xxxLarge)
}

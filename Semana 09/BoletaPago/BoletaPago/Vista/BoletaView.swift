import SwiftUI

struct BoletaView: View {
    let boleta: Boleta

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("REMUNERACIONES").font(.headline)
            fila(boleta.remuneraciones[0])
            fila(boleta.remuneraciones[1])
            fila(boleta.remuneraciones[2])
            fila(boleta.remuneraciones[3])
            total("Total remuneraciones", boleta.totalRemuneraciones, id: "total-remuneraciones")
            Text("RETENCIONES / DESCUENTOS").font(.headline).padding(.top, 8)
            fila(boleta.descuentos[0])
            fila(boleta.descuentos[1])
            fila(boleta.descuentos[2])
            fila(boleta.descuentos[3])
            fila(boleta.descuentos[4])
            total("Total descuentos", boleta.totalDescuentos, id: "total-descuentos")
            Text("APORTACIONES DEL EMPLEADOR").font(.headline).padding(.top, 8)
            fila(boleta.aportaciones[0])
            Text("Lo paga la empresa; no se resta al trabajador.").font(.footnote)
            total("NETO A PAGAR", boleta.netoAPagar, id: "neto")
        }.padding(.top, 12)
    }

    private func fila(_ concepto: Concepto) -> some View {
        HStack {
            Text(concepto.nombre).frame(maxWidth: .infinity, alignment: .leading)
            Text(concepto.monto.formatoSoles()).monospacedDigit()
                .accessibilityIdentifier("monto-" + concepto.nombre)
        }
    }

    private func total(_ nombre: String, _ monto: Decimal, id: String) -> some View {
        HStack {
            Text(nombre).frame(maxWidth: .infinity, alignment: .leading)
            Text("S/ " + monto.formatoSoles()).monospacedDigit()
                .accessibilityIdentifier(id)
        }.bold()
    }
}

import SwiftUI
import UIKit

// Una pantalla y los controles de la guía. El cálculo vive en el modelo.
struct ContentView: View {
    @State private var sueldo = ""
    @State private var dias = ""
    @State private var tieneHijos = false
    @State private var sistema = SistemaPension.onp
    @State private var afp = "AFP Ejemplo"
    @State private var horasExtras25 = ""
    @State private var horasExtras35 = ""
    @State private var adelantos = ""
    @State private var mensajeError: String?
    @State private var boleta: Boleta?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Boleta de ejemplo").font(.largeTitle).bold()
                Text("Datos ficticios · Montos en soles").foregroundStyle(.secondary)
                Text("Datos del mes").font(.headline)
                campo("Sueldo básico", texto: $sueldo)
                campo("Días laborados (1 a 30)", texto: $dias, entero: true)
                Text("¿Tiene hijos?")
                Picker("¿Tiene hijos?", selection: $tieneHijos) {
                    Text("No").tag(false)
                    Text("Sí").tag(true)
                }.pickerStyle(.segmented).accessibilityIdentifier("hijos")
                Text("Sistema de pensiones")
                Picker("Sistema de pensiones", selection: $sistema) {
                    Text("ONP").tag(SistemaPension.onp)
                    Text("AFP").tag(SistemaPension.afp)
                }.pickerStyle(.segmented).accessibilityIdentifier("pension")
                if sistema == .afp {
                    Picker("AFP", selection: $afp) {
                        Text("AFP Ejemplo").tag("AFP Ejemplo")
                        Text("Habitat").tag("Habitat")
                        Text("Integra").tag("Integra")
                        Text("Prima").tag("Prima")
                        Text("Profuturo").tag("Profuturo")
                    }.accessibilityIdentifier("afp")
                    Text("Comisión sobre flujo. AFP Ejemplo corresponde a los casos de la guía.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                campo("Horas extras al 25%", texto: $horasExtras25)
                campo("Horas extras al 35%", texto: $horasExtras35)
                campo("Adelantos", texto: $adelantos)
                Button("Calcular boleta") { calcular() }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("calcular")
                if let mensajeError = mensajeError {
                    Text(mensajeError).foregroundStyle(.red)
                        .accessibilityIdentifier("error-validacion")
                }
                if let boleta = boleta {
                    BoletaView(boleta: boleta)
                }
            }.padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .clipped()
    }

    private func campo(_ nombre: String, texto: Binding<String>, entero: Bool = false) -> some View {
        HStack {
            Text(nombre).frame(maxWidth: .infinity, alignment: .leading)
            TextField("0", text: texto)
                .keyboardType(entero ? .numberPad : .decimalPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 115)
                .accessibilityLabel(nombre)
                .accessibilityIdentifier(nombre)
        }
    }

    private func calcular() {
        // El teclado decimal no tiene Return: se cierra al calcular para leer la boleta.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        let formulario = FormularioBoleta(
            sueldo: sueldo, dias: dias, tieneHijos: tieneHijos,
            sistema: sistema, afp: afp, horasExtras25: horasExtras25,
            horasExtras35: horasExtras35, adelantos: adelantos
        )
        switch formulario.validar() {
        case .failure(let error):
            mensajeError = error.mensaje
            boleta = nil
        case .success(let datos):
            mensajeError = nil
            let nueva = Boleta(datos: datos)
            nueva.calcular()
            boleta = nueva
        }
    }
}

#Preview { ContentView() }

import SwiftUI

// Pantalla única: formulario arriba y, al pulsar Calcular, la boleta debajo.
struct ContentView: View {
    @State private var sueldo = ""
    @State private var dias = ""
    @State private var tieneHijos = false
    @State private var sistema = SistemaPension.onp
    @State private var afp = Parametros.nombresAFP.first ?? ""
    @State private var horasExtras25 = ""
    @State private var horasExtras35 = ""
    @State private var adelantos = ""

    @State private var mensajeError: String? = nil
    @State private var boleta: Boleta? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Boleta de pago")
                    .font(.largeTitle)
                    .bold()
                Text("Ingresa los datos del mes. Boleta de ejemplo con datos ficticios.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                campo("Sueldo básico (S/)", texto: $sueldo, teclado: .decimalPad)
                campo("Días laborados (1 a 30)", texto: $dias, teclado: .numberPad)

                Text("¿Tiene hijos?")
                Picker("¿Tiene hijos?", selection: $tieneHijos) {
                    Text("No").tag(false)
                    Text("Sí").tag(true)
                }
                .pickerStyle(.segmented)

                Text("Sistema de pensiones")
                Picker("Sistema de pensiones", selection: $sistema) {
                    ForEach(SistemaPension.allCases, id: \.self) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                .pickerStyle(.segmented)

                // Solo aparece si eligió AFP
                if sistema == .afp {
                    Text("AFP")
                    Picker("AFP", selection: $afp) {
                        ForEach(Parametros.nombresAFP, id: \.self) { nombre in
                            Text(nombre).tag(nombre)
                        }
                    }
                    .pickerStyle(.menu)
                }

                campo("Horas extras al 25%", texto: $horasExtras25, teclado: .decimalPad)
                campo("Horas extras al 35%", texto: $horasExtras35, teclado: .decimalPad)
                campo("Adelantos (S/)", texto: $adelantos, teclado: .decimalPad)

                Button("Calcular") {
                    calcular()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, minHeight: 44)

                if let mensajeError = mensajeError {
                    Text(mensajeError)
                        .foregroundStyle(.red)
                }

                if let boleta = boleta {
                    BoletaView(boleta: boleta)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func campo(_ titulo: String, texto: Binding<String>, teclado: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
            TextField(titulo, text: texto)
                .keyboardType(teclado)
                .textFieldStyle(.roundedBorder)
                .frame(minHeight: 44)
        }
    }

    private func calcular() {
        let formulario = FormularioBoleta(
            sueldo: sueldo, dias: dias, tieneHijos: tieneHijos,
            sistema: sistema, afp: afp,
            horasExtras25: horasExtras25, horasExtras35: horasExtras35,
            adelantos: adelantos
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

#Preview("Claro") {
    ContentView()
}

#Preview("Oscuro, texto grande") {
    ContentView()
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.xxxLarge)
}

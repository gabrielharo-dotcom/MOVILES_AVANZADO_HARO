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
    @State private var calculos = 0   // sube en cada cálculo exitoso; dispara el desplazamiento

    var body: some View {
        ScrollViewReader { lector in
            ScrollView {
                VStack(spacing: Estilo.espacio) {
                    encabezado

                    seccion("Datos del trabajador") {
                        campo("Sueldo básico", prefijo: "S/", ejemplo: "2500.00", texto: $sueldo, teclado: .decimalPad)
                        campo("Días laborados (1 a 30)", prefijo: nil, ejemplo: "30", texto: $dias, teclado: .numberPad)
                        etiqueta("¿Tiene hijos?")
                        Picker("¿Tiene hijos?", selection: $tieneHijos) {
                            Text("No").tag(false)
                            Text("Sí").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }

                    seccion("Sistema de pensiones") {
                        Picker("Sistema de pensiones", selection: $sistema) {
                            ForEach(SistemaPension.allCases, id: \.self) { opcion in
                                Text(opcion.rawValue).tag(opcion)
                            }
                        }
                        .pickerStyle(.segmented)

                        // Solo aparece si eligió AFP
                        if sistema == .afp {
                            etiqueta("AFP")
                            Picker("AFP", selection: $afp) {
                                ForEach(Parametros.nombresAFP, id: \.self) { nombre in
                                    Text(nombre).tag(nombre)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .aspectoCampo()
                            Text(detalleAFP)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("ONP: \(Parametros.tasaONP.formatoPorcentaje(decimales: 0)) del total de remuneraciones.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    seccion("Pagos adicionales (opcional)") {
                        campo("Horas extras al 25%", prefijo: nil, ejemplo: "0", texto: $horasExtras25, teclado: .decimalPad)
                        campo("Horas extras al 35%", prefijo: nil, ejemplo: "0", texto: $horasExtras35, teclado: .decimalPad)
                        campo("Adelantos", prefijo: "S/", ejemplo: "0.00", texto: $adelantos, teclado: .decimalPad)
                    }

                    Button("Calcular boleta") {
                        calcular()
                    }
                    .buttonStyle(BotonPrincipal())

                    if let mensajeError = mensajeError {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Revisa los datos")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(mensajeError)
                                .font(.subheadline)
                        }
                        .foregroundStyle(Color(UIColor.systemRed))
                        .padding(Estilo.espacio)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.systemRed).opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .accessibilityElement(children: .combine)
                    }

                    if let boleta = boleta {
                        BoletaView(boleta: boleta)
                            .id("resultado")
                    }
                }
                .padding(Estilo.espacio)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Estilo.fondoPantalla.ignoresSafeArea())
            // Al calcular, la pantalla baja sola hasta la boleta.
            .onChange(of: calculos) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    lector.scrollTo("resultado", anchor: .top)
                }
            }
        }
    }

    // MARK: - Piezas de la pantalla

    private var encabezado: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("BOLETA DE EJEMPLO")
                .font(.caption2)
                .fontWeight(.bold)
                .tracking(1)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
            Text("Boleta de pago")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Del sueldo básico al neto a pagar. Datos ficticios.")
                .font(.subheadline)
                .opacity(0.9)
        }
        .foregroundStyle(.white)
        .padding(Estilo.espacio * 1.25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Estilo.degradado)
        .clipShape(RoundedRectangle(cornerRadius: Estilo.radio, style: .continuous))
    }

    private func seccion<Contenido: View>(_ titulo: String, @ViewBuilder contenido: () -> Contenido) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(titulo)
                .font(.headline)
            contenido()
        }
        .tarjeta()
    }

    private func etiqueta(_ titulo: String) -> some View {
        Text(titulo)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
    }

    private func campo(_ titulo: String, prefijo: String?, ejemplo: String, texto: Binding<String>, teclado: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            etiqueta(titulo)
            HStack(spacing: 8) {
                if let prefijo = prefijo {
                    Text(prefijo)
                        .foregroundStyle(.secondary)
                }
                TextField(ejemplo, text: texto)
                    .keyboardType(teclado)
                    .accessibilityLabel(titulo)
            }
            .aspectoCampo()
        }
    }

    private var detalleAFP: String {
        guard let tasas = Parametros.tasasAFP[afp] else { return "" }
        let fondo = tasas.fondo.formatoPorcentaje(decimales: 2)
        let comision = tasas.comision.formatoPorcentaje(decimales: 2)
        let seguro = tasas.seguro.formatoPorcentaje(decimales: 2)
        return "Fondo \(fondo) · Comisión \(comision) · Seguro \(seguro)"
    }

    // MARK: - Acción

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
            calculos += 1
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

import UIKit
import CoreData

final class ResumenViewController: Formulario {
    private let almacen: Almacen
    private let cuenta: Usuario
    private let localidad = Locale(identifier: "es_PE")

    init(almacen: Almacen, cuenta: Usuario) {
        self.almacen = almacen
        self.cuenta = cuenta
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizar()
    }

    private func actualizar() {
        for vista in contenido.arrangedSubviews { vista.removeFromSuperview() }
        let ahora = Date()
        let calendario = Calendar.current
        let hoy = calendario.startOfDay(for: ahora)
        let dias = (0...6).reversed().compactMap { calendario.date(byAdding: .day, value: -$0, to: hoy) }
        guard let primero = dias.first,
              let manana = calendario.date(byAdding: .day, value: 1, to: hoy),
              let ayer = calendario.date(byAdding: .day, value: -1, to: hoy),
              let mes = calendario.dateInterval(of: .month, for: ahora) else { return }
        contenido.addArrangedSubview(etiqueta(ahora.formatted(.dateTime.weekday(.wide).day().month(.wide).locale(localidad)),
                                              estilo: .subheadline, color: .secondaryLabel))
        contenido.addArrangedSubview(etiqueta("Hola, \(cuenta.nombre)", estilo: .largeTitle))
        contenido.addArrangedSubview(etiqueta(cuenta.rol, estilo: .headline, color: .systemPurple))
        do {
            let semana = try almacen.ventas(intervalo: DateInterval(start: primero, end: manana), soloActivas: true)
            let ventasMes = try almacen.ventas(intervalo: mes, soloActivas: true)
            let stockBajo = try almacen.buscar(Producto.self, donde: NSPredicate(format: "stock <= 5"),
                                              orden: [NSSortDescriptor(key: "stock", ascending: true),
                                                      NSSortDescriptor(key: "nombre", ascending: true)])
            let porDia = Dictionary(grouping: semana) { calendario.startOfDay(for: $0.fecha) }
            let ventasHoy = total(porDia[hoy] ?? [])
            let ventasAyer = total(porDia[ayer] ?? [])
            let cambio = comparacion(hoy: ventasHoy, ayer: ventasAyer)
            let indicadores = UIStackView(arrangedSubviews: [
                tarjeta([etiqueta("Vendido hoy", estilo: .subheadline), etiqueta(soles(ventasHoy), estilo: .title2),
                         etiqueta(cambio, estilo: .footnote, color: ventasHoy >= ventasAyer ? .systemGreen : .systemRed)]),
                tarjeta([etiqueta("IGV del mes", estilo: .subheadline),
                         etiqueta(soles(ventasMes.reduce(0) { $0 + $1.igv }), estilo: .title2)]),
            ])
            indicadores.spacing = 10
            indicadores.distribution = .fillEqually
            indicadores.alignment = .fill
            contenido.addArrangedSubview(indicadores)
            contenido.addArrangedSubview(tarjeta([etiqueta("Ventas de los últimos 7 días", estilo: .headline),
                                                 grafico(dias.map { ($0, total(porDia[$0] ?? [])) })]))
            contenido.addArrangedSubview(ranking(ventasMes))
            let productos = stockBajo.map { etiqueta("\($0.nombre) · \($0.stock) u.", color: .systemRed) }
            contenido.addArrangedSubview(tarjeta([etiqueta("Stock bajo (5 u. o menos)", estilo: .headline)]
                + (productos.isEmpty ? [etiqueta("Sin productos con stock bajo", color: .secondaryLabel)] : productos)))
        } catch { avisar("Resumen", error.localizedDescription) }
    }

    private func total(_ ventas: [Venta]) -> Double { ventas.reduce(0) { $0 + $1.total } }

    private func comparacion(hoy: Double, ayer: Double) -> String {
        guard ayer > 0 else { return hoy > 0 ? "Ayer sin ventas" : "Sin ventas hoy ni ayer" }
        let cambio = (hoy - ayer) / ayer
        let porcentaje = cambio.formatted(.percent.precision(.fractionLength(0)).locale(localidad))
        return (cambio > 0 ? "+" : "") + porcentaje + " vs. ayer"
    }

    private func tarjeta(_ vistas: [UIView]) -> UIStackView {
        let tarjeta = UIStackView(arrangedSubviews: vistas)
        tarjeta.axis = .vertical
        tarjeta.spacing = 8
        tarjeta.isLayoutMarginsRelativeArrangement = true
        tarjeta.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12)
        tarjeta.backgroundColor = .secondarySystemGroupedBackground
        tarjeta.layer.cornerRadius = 14
        return tarjeta
    }

    private func grafico(_ datos: [(Date, Double)]) -> UIStackView {
        let maximo = datos.map { $0.1 }.max() ?? 0
        let columnas = UIStackView()
        columnas.distribution = .fillEqually
        columnas.spacing = 5
        for (indice, dato) in datos.enumerated() {
            let (fecha, monto) = dato
            let contenedor = UIView()
            let barra = UIView()
            barra.backgroundColor = indice == datos.count - 1 ? .systemBlue : .systemBlue.withAlphaComponent(0.35)
            barra.layer.cornerRadius = 3
            barra.translatesAutoresizingMaskIntoConstraints = false
            contenedor.addSubview(barra)
            let altura = maximo > 0 ? CGFloat(90 * monto / maximo) : 0
            NSLayoutConstraint.activate([
                contenedor.heightAnchor.constraint(equalToConstant: 92),
                barra.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 3),
                barra.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -3),
                barra.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor),
                barra.heightAnchor.constraint(equalToConstant: max(2, altura)),
            ])
            let dia = etiqueta(fecha.formatted(.dateTime.day().locale(localidad)), estilo: .caption2, color: .secondaryLabel)
            dia.textAlignment = .center
            let columna = UIStackView(arrangedSubviews: [contenedor, dia])
            columna.axis = .vertical
            columna.spacing = 4
            columna.isAccessibilityElement = true
            columna.accessibilityLabel = fecha.formatted(.dateTime.weekday(.wide).day().month(.wide).locale(localidad)) + ", " + soles(monto)
            columnas.addArrangedSubview(columna)
        }
        return columnas
    }

    private func ranking(_ ventas: [Venta]) -> UIStackView {
        let grupos = Dictionary(grouping: ventas, by: \.vendedor)
        let orden = grupos.map { (cuenta: $0.key, monto: total($0.value)) }.sorted { primero, segundo in
            if primero.monto == segundo.monto { return primero.cuenta.usuario < segundo.cuenta.usuario }
            return primero.monto > segundo.monto
        }
        var filas: [UIView] = [etiqueta("Ranking de vendedores del mes", estilo: .headline)]
        if orden.isEmpty { filas.append(etiqueta("Sin ventas activas este mes", color: .secondaryLabel)) }
        let maximo = orden.first?.monto ?? 0
        for (indice, fila) in orden.enumerated() {
            filas.append(etiqueta("\(indice + 1). \(fila.cuenta.nombre) (@\(fila.cuenta.usuario)) · \(soles(fila.monto))", estilo: .subheadline))
            if maximo > 0 {
                let progreso = UIProgressView(progressViewStyle: .default)
                progreso.progress = Float(fila.monto / maximo)
                progreso.accessibilityElementsHidden = true
                filas.append(progreso)
            }
        }
        return tarjeta(filas)
    }
}

import UIKit
import CoreData

enum Periodo: String, CaseIterable {
    case todas = "Todas"
    case hoy = "Hoy"
    case mes = "Mes"

    func intervalo(ahora: Date = Date(), calendario: Calendar = .current) -> DateInterval? {
        switch self {
        case .todas: return nil
        case .hoy: return calendario.dateInterval(of: .day, for: ahora)
        case .mes: return calendario.dateInterval(of: .month, for: ahora)
        }
    }
}

extension Almacen {
    func ventas(intervalo: DateInterval? = nil, vendedor: Usuario? = nil,
                cliente: String = "", soloActivas: Bool = false) throws -> [Venta] {
        guard let cuenta = usuarioActual else { throw ErrorVentas("Inicia sesión para consultar ventas.") }
        var filtros: [NSPredicate] = []
        if let vendedor = cuenta.esSupervisor ? vendedor : cuenta {
            filtros.append(NSPredicate(format: "vendedor == %@", vendedor))
        }
        if let intervalo {
            filtros.append(NSPredicate(format: "fecha >= %@ AND fecha < %@", intervalo.start as NSDate, intervalo.end as NSDate))
        }
        if !cliente.isEmpty { filtros.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", cliente)) }
        if soloActivas { filtros.append(NSPredicate(format: "anulada == NO")) }
        return try buscar(Venta.self, donde: NSCompoundPredicate(andPredicateWithSubpredicates: filtros),
                          orden: [NSSortDescriptor(key: "fecha", ascending: false)])
    }
}

final class HistorialViewController: Listado {
    private let almacen: Almacen
    private let periodos = UISegmentedControl(items: Periodo.allCases.map(\.rawValue))
    private let hoy = etiqueta("", estilo: .subheadline)
    private let mes = etiqueta("", estilo: .subheadline)
    private var filas: [Venta] = []

    init(almacen: Almacen) {
        self.almacen = almacen
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis ventas"
        let indicadores = UIStackView(arrangedSubviews: [hoy, mes])
        indicadores.distribution = .fillEqually
        indicadores.spacing = 8
        controles.addArrangedSubview(indicadores)
        periodos.selectedSegmentIndex = 0
        periodos.addAction(UIAction { [weak self] _ in self?.actualizar() }, for: .valueChanged)
        buscador.placeholder = "Buscar por cliente"
        controles.addArrangedSubview(periodos)
        controles.addArrangedSubview(buscador)
    }

    override func actualizar() {
        do {
            let periodo = Periodo.allCases[periodos.selectedSegmentIndex]
            filas = try almacen.ventas(intervalo: periodo.intervalo(), cliente: buscador.text ?? "")
            let ventasHoy = try almacen.ventas(intervalo: Periodo.hoy.intervalo(), soloActivas: true)
            let ventasMes = try almacen.ventas(intervalo: Periodo.mes.intervalo(), soloActivas: true)
            hoy.text = resumen("Hoy", ventasHoy)
            mes.text = resumen("Mes", ventasMes)
            mostrarFilas(filas.count, vacio: "No hay ventas para estos filtros.")
        } catch { avisar("Ventas", error.localizedDescription) }
    }

    private func resumen(_ periodo: String, _ ventas: [Venta]) -> String {
        "\(periodo)\n\(soles(ventas.reduce(0) { $0 + $1.total }))\n\(ventas.count) ventas"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filas.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venta = filas[indexPath.row]
        let fecha = venta.fecha.formatted(.dateTime.day().month(.twoDigits).locale(Locale(identifier: "es_PE")))
        var detalle = "\(fecha) · \(venta.producto.nombre) × \(venta.cantidad)"
        if venta.anulada { detalle += "\nAnulada" }
        return filaDetalle(venta.cliente.nombre, detalle, valor: soles(venta.total),
                           color: venta.anulada ? .systemRed : .systemGreen,
                           icono: venta.anulada ? "xmark.circle.fill" : "checkmark.circle.fill",
                           tachada: venta.anulada)
    }
}

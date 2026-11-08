import UIKit
import CoreData

enum CategoriaCliente: String {
    case regular = "Regular"
    case frecuente = "Frecuente"
    case vip = "VIP"

    init(total: Decimal) {
        if total >= 5000 { self = .vip }
        else if total >= 1000 { self = .frecuente }
        else { self = .regular }
    }
}

extension Cliente {
    var totalComprado: Decimal {
        let activas = (ventas?.allObjects as? [Venta] ?? []).filter { !$0.anulada }
        return activas.reduce(Decimal.zero) { $0 + decimalMoneda($1.total) }
    }
}

func decimalMoneda(_ valor: Double) -> Decimal {
    Decimal(string: String(valor), locale: Locale(identifier: "en_US_POSIX")) ?? 0
}

extension Almacen {
    func clientes(texto: String = "") throws -> [Cliente] {
        let filtro = texto.isEmpty ? nil : NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        return try buscar(Cliente.self, donde: filtro, orden: [NSSortDescriptor(key: "nombre", ascending: true)])
    }

    func guardarCliente(_ cliente: Cliente?, nombre: String, documento: String) throws {
        guard usuarioActual != nil else { throw ErrorVentas("Inicia sesión para guardar clientes.") }
        guard !nombre.isEmpty, !documento.isEmpty else { throw ErrorVentas("Completa el nombre y el documento.") }
        let item = cliente ?? Cliente(context: contexto)
        item.nombre = nombre
        item.documento = documento
        try guardar()
    }
}

final class ClientesViewController: Listado {
    private let almacen: Almacen
    private let supervisor: Bool
    private var filas: [Cliente] = []

    init(almacen: Almacen, supervisor: Bool) {
        self.almacen = almacen
        self.supervisor = supervisor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        buscador.placeholder = "Buscar por nombre o documento"
        controles.addArrangedSubview(buscador)
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.editar(nil)
        })
    }

    override func actualizar() {
        do {
            filas = try almacen.clientes(texto: buscador.text ?? "")
            mostrarFilas(filas.count, vacio: "No hay clientes para esta búsqueda.")
        } catch { avisar("Clientes", error.localizedDescription) }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filas.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cliente = filas[indexPath.row]
        let total = cliente.totalComprado
        let categoria = CategoriaCliente(total: total)
        let color: UIColor = categoria == .vip ? .systemPurple : categoria == .frecuente ? .systemBlue : .secondaryLabel
        return filaDetalle(cliente.nombre, "\(cliente.documento) · \(categoria.rawValue)",
                           valor: soles(NSDecimalNumber(decimal: total).doubleValue), color: color,
                           icono: "person.crop.circle.fill", editable: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        editar(filas[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard supervisor else { return nil }
        let cliente = filas[indexPath.row]
        return accionDeslizante("Borrar") { [weak self] in
            guard let self else { return false }
            do {
                try almacen.borrar(cliente, ventas: cliente.ventas, entidad: "el cliente")
                actualizar()
                return true
            } catch {
                avisar("No se pudo borrar", error.localizedDescription)
                return false
            }
        }
    }

    private func editar(_ cliente: Cliente?) {
        let editor = Formulario()
        editor.title = cliente == nil ? "Nuevo cliente" : "Editar cliente"
        editor.loadViewIfNeeded()
        let nombre = campo("Nombre")
        let documento = campo("Documento")
        nombre.text = cliente?.nombre
        documento.text = cliente?.documento
        editor.contenido.addArrangedSubview(nombre)
        editor.contenido.addArrangedSubview(documento)
        editor.contenido.addArrangedSubview(boton("Guardar") { [weak self, weak editor, weak nombre, weak documento] in
            guard let self, let editor, let nombre, let documento else { return }
            do {
                try almacen.guardarCliente(cliente, nombre: nombre.textoLimpio, documento: documento.textoLimpio)
                editor.navigationController?.popViewController(animated: true)
            } catch { editor.avisar("No se pudo guardar", error.localizedDescription) }
        })
        navigationController?.pushViewController(editor, animated: true)
    }
}

import UIKit
import CoreData

extension Almacen {
    func productos(texto: String = "", categoria: String? = nil) throws -> [Producto] {
        var filtros: [NSPredicate] = []
        if !texto.isEmpty { filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto)) }
        if let categoria { filtros.append(NSPredicate(format: "categoria == %@", categoria)) }
        return try buscar(Producto.self, donde: NSCompoundPredicate(andPredicateWithSubpredicates: filtros),
                          orden: [NSSortDescriptor(key: "nombre", ascending: true)])
    }

    func guardarProducto(_ producto: Producto?, nombre: String, categoria: String, precio: Double, stock: Int64) throws {
        guard usuarioActual?.esSupervisor == true else { throw ErrorVentas("Se requiere el rol Supervisor.") }
        guard !nombre.isEmpty, !categoria.isEmpty, precio.isFinite, precio > 0, stock >= 0 else {
            throw ErrorVentas("Completa el nombre, la categoría, un precio mayor que cero y un stock válido.")
        }
        let item = producto ?? Producto(context: contexto)
        item.nombre = nombre
        item.categoria = categoria
        item.precio = precio
        item.stock = stock
        try guardar()
    }

    func borrar(_ objeto: NSManagedObject, ventas: NSSet?, entidad: String) throws {
        guard usuarioActual?.esSupervisor == true else { throw ErrorVentas("Se requiere el rol Supervisor.") }
        guard (ventas?.count ?? 0) == 0 else { throw ErrorVentas("No se puede borrar: \(entidad) tiene ventas registradas.") }
        contexto.delete(objeto)
        try guardar()
    }
}

func soles(_ valor: Double) -> String {
    "S/ " + valor.formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "es_PE")))
}

final class ProductosViewController: Listado {
    private let almacen: Almacen
    private let supervisor: Bool
    private let filtros = Filtros()
    private var categoria: String?
    private var categorias: [String] = []
    private var filas: [Producto] = []

    init(almacen: Almacen, supervisor: Bool) {
        self.almacen = almacen
        self.supervisor = supervisor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        buscador.placeholder = "Buscar producto"
        controles.addArrangedSubview(buscador)
        controles.addArrangedSubview(filtros)
        if supervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
                self?.editar(nil)
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        do {
            categorias = Array(Set(try almacen.productos().map(\.categoria))).sorted()
            if let categoria, !categorias.contains(categoria) { self.categoria = nil }
            mostrarFiltros()
        } catch { avisar("Productos", error.localizedDescription) }
        super.viewWillAppear(animated)
    }

    private func mostrarFiltros() {
        let seleccion = categoria.flatMap { categorias.firstIndex(of: $0) }.map { $0 + 1 } ?? 0
        filtros.mostrar(["Todos"] + categorias, seleccion: seleccion) { [weak self] indice in
            guard let self else { return }
            categoria = indice == 0 ? nil : categorias[indice - 1]
            mostrarFiltros()
            actualizar()
        }
    }

    override func actualizar() {
        do {
            filas = try almacen.productos(texto: buscador.text ?? "", categoria: categoria)
            mostrarFilas(filas.count, vacio: "No hay productos para esta búsqueda.")
        } catch { avisar("Productos", error.localizedDescription) }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filas.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filas[indexPath.row]
        let color: UIColor = item.stock <= 5 ? .systemRed : item.stock <= 10 ? .systemOrange : .systemGreen
        return filaDetalle(item.nombre, "\(item.categoria) · \(soles(item.precio))",
                           valor: "\(item.stock) u.", color: color, icono: "shippingbox", editable: supervisor)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if supervisor { editar(filas[indexPath.row]) }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard supervisor else { return nil }
        let item = filas[indexPath.row]
        return accionDeslizante("Borrar") { [weak self] in
            guard let self else { return false }
            do {
                try almacen.borrar(item, ventas: item.ventas, entidad: "el producto")
                viewWillAppear(false)
                return true
            } catch {
                avisar("No se pudo borrar", error.localizedDescription)
                return false
            }
        }
    }

    private func editar(_ item: Producto?) {
        let editor = Formulario()
        editor.title = item == nil ? "Nuevo producto" : "Editar producto"
        editor.loadViewIfNeeded()
        let nombre = campo("Nombre")
        let categoria = campo("Categoría")
        let precio = campo("Precio en soles")
        let stock = campo("Stock")
        precio.keyboardType = .decimalPad
        stock.keyboardType = .numberPad
        nombre.text = item?.nombre
        categoria.text = item?.categoria
        precio.text = item.map { String($0.precio) }
        stock.text = item.map { String($0.stock) }
        for campo in [nombre, categoria, precio, stock] { editor.contenido.addArrangedSubview(campo) }
        editor.contenido.addArrangedSubview(boton("Guardar") { [weak editor, weak self, weak nombre, weak categoria, weak precio, weak stock] in
            guard let self, let editor, let nombre, let categoria, let precio, let stock else { return }
            let texto = precio.textoLimpio.replacingOccurrences(of: ",", with: ".")
            guard texto.range(of: #"^[0-9]+(\.[0-9]{1,2})?$"#, options: .regularExpression) != nil,
                  let monto = Double(texto), monto <= 999_999_999, let unidades = Int64(stock.textoLimpio),
                  (0...999_999_999).contains(unidades) else {
                editor.avisar("Revisa el producto", "Escribe un precio de hasta dos decimales y un stock entero no negativo.")
                return
            }
            do {
                try almacen.guardarProducto(item, nombre: nombre.textoLimpio, categoria: categoria.textoLimpio,
                                            precio: monto, stock: unidades)
                editor.navigationController?.popViewController(animated: true)
            } catch { editor.avisar("No se pudo guardar", error.localizedDescription) }
        })
        navigationController?.pushViewController(editor, animated: true)
    }
}

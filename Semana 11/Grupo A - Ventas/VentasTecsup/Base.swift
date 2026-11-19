import UIKit
import CoreData

final class AccesoBaseViewController: UIViewController {
    private let almacen: Almacen
    private let alAcceder: () -> Void
    private let usuario = UITextField()
    private let clave = UITextField()

    init(almacen: Almacen, alAcceder: @escaping () -> Void) {
        self.almacen = almacen
        self.alAcceder = alAcceder
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ingreso"
        view.backgroundColor = .systemBackground
        usuario.placeholder = "Usuario"
        usuario.borderStyle = .roundedRect
        usuario.autocapitalizationType = .none
        clave.placeholder = "Contraseña"
        clave.isSecureTextEntry = true
        clave.borderStyle = .roundedRect
        let ingresar = UIButton(type: .system)
        ingresar.setTitle("Ingresar", for: .normal)
        ingresar.addAction(UIAction { [weak self] _ in self?.ingresar() }, for: .touchUpInside)
        let registro = UIButton(type: .system)
        registro.setTitle("Registrar cuenta de prueba", for: .normal)
        registro.addAction(UIAction { [weak self] _ in self?.registrar() }, for: .touchUpInside)
        let columna = UIStackView(arrangedSubviews: [usuario, clave, ingresar, registro])
        columna.axis = .vertical
        columna.spacing = 18
        columna.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(columna)
        NSLayoutConstraint.activate([
            columna.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            columna.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            columna.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func ingresar() {
        do {
            try almacen.ingresar(usuario: usuario.text ?? "", clave: clave.text ?? "")
            alAcceder()
        } catch { mostrar(error.localizedDescription) }
    }

    private func registrar() {
        let alerta = UIAlertController(title: "Crear cuenta", message: "Completo los datos de mi usuario de prueba", preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre completo" }
        alerta.addTextField { $0.placeholder = "Usuario" }
        alerta.addTextField { $0.placeholder = "Clave (6 caracteres mínimo)"; $0.isSecureTextEntry = true }
        alerta.addTextField { $0.placeholder = "Confirmar clave"; $0.isSecureTextEntry = true }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Registrar", style: .default) { [weak self, weak alerta] _ in
            guard let self, let campos = alerta?.textFields, campos.count == 4 else { return }
            do {
                try almacen.registrar(nombre: campos[0].text ?? "", usuario: campos[1].text ?? "",
                                     clave: campos[2].text ?? "", confirmacion: campos[3].text ?? "", rol: .supervisor)
                alAcceder()
            } catch { mostrar(error.localizedDescription) }
        })
        present(alerta, animated: true)
    }

    private func mostrar(_ mensaje: String) {
        let alerta = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}

final class ProductosBaseViewController: UITableViewController {
    private let almacen: Almacen
    private let alSalir: () -> Void
    private var productos: [Producto] = []

    init(almacen: Almacen, alSalir: @escaping () -> Void) {
        self.almacen = almacen
        self.alSalir = alSalir
        super.init(style: .insetGrouped)
    }
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos - versión base"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(salir))
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, target: self, action: #selector(agregar))
        tablaActualizar()
    }

    @objc private func salir() { alSalir() }

    @objc private func agregar() {
        let alerta = UIAlertController(title: "Nuevo producto", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre" }
        alerta.addTextField { $0.placeholder = "Categoría" }
        alerta.addTextField { $0.placeholder = "Precio"; $0.keyboardType = .decimalPad }
        alerta.addTextField { $0.placeholder = "Stock"; $0.keyboardType = .numberPad }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            guard let self, let c = alerta?.textFields, c.count == 4,
                  let precio = Double((c[2].text ?? "").replacingOccurrences(of: ",", with: ".")),
                  let stock = Int64(c[3].text ?? ""), precio > 0, stock >= 0,
                  !(c[0].text ?? "").isEmpty else { return }
            let producto = Producto(context: almacen.contexto)
            producto.nombre = c[0].text ?? ""
            producto.categoria = c[1].text ?? ""
            producto.precio = precio
            producto.stock = stock
            do {
                try almacen.guardar()
                tablaActualizar()
            } catch { almacen.contexto.rollback() }
        })
        present(alerta, animated: true)
    }

    private func tablaActualizar() {
        let solicitud = NSFetchRequest<Producto>(entityName: "Producto")
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        productos = (try? almacen.contexto.fetch(solicitud)) ?? []
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { productos.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let p = productos[indexPath.row]
        let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        celda.textLabel?.text = p.nombre
        celda.detailTextLabel?.text = "\(p.categoria) · S/ \(p.precio) · Stock: \(p.stock)"
        return celda
    }
}

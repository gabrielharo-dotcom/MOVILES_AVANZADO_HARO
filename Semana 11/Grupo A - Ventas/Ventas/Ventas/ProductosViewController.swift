//
//  ProductosViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class ProductosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var buscador: UISearchBar!
    @IBOutlet weak var stackChips: UIStackView!
    @IBOutlet weak var lblNota: UILabel!

    var productos = [Producto]()
    var categorias = [String]()
    var categoriaElegida = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.dataSource = self
        tabla.delegate = self
        buscador.delegate = self
        if Sesion.shared.esSupervisor {
            lblNota.text = "Vista del supervisor: crea con +, edita tocando la fila y borra deslizando."
        } else {
            navigationItem.rightBarButtonItem = nil
            lblNota.text = "Vista del vendedor: solo consulta y búsqueda."
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    func cargar() {
        let todos: NSFetchRequest<Producto> = Producto.fetchRequest()
        let lista = (try? Datos.contexto.fetch(todos)) ?? []
        categorias = Array(Set(lista.compactMap { $0.categoria })).sorted()
        if categoriaElegida > categorias.count {
            categoriaElegida = 0
        }
        Estilo.llenarChips(stackChips, titulos: ["Todos"] + categorias, seleccionado: categoriaElegida) { [weak self] indice in
            self?.categoriaElegida = indice
            self?.cargar()
        }

        var condiciones = [NSPredicate]()
        if categoriaElegida > 0 {
            condiciones.append(NSPredicate(format: "categoria == %@", categorias[categoriaElegida - 1]))
        }
        let texto = (buscador.text ?? "").trimmingCharacters(in: .whitespaces)
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))
        }
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        productos = (try? Datos.contexto.fetch(request)) ?? []
        tabla.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "fila", for: indexPath) as! FilaCell
        let producto = productos[indexPath.row]
        celda.configurar(iniciales: Datos.iniciales(producto.nombre),
                         color: Estilo.color(para: producto.nombre),
                         titulo: producto.nombre ?? "",
                         subtitulo: producto.categoria ?? "",
                         monto: Datos.soles(producto.precio),
                         etiqueta: "\(producto.stock) u.",
                         colorEtiqueta: Estilo.colorStock(producto.stock))
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if Sesion.shared.esSupervisor {
            formulario(productos[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return nil }
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminado in
            self?.borrar(indexPath)
            terminado(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    func borrar(_ indexPath: IndexPath) {
        let producto = productos[indexPath.row]
        if (producto.ventas?.count ?? 0) > 0 {
            avisar("No se puede borrar", "\(producto.nombre ?? "El producto") tiene ventas registradas.")
            return
        }
        Datos.contexto.delete(producto)
        if Datos.guardar() {
            cargar()
        } else {
            avisar("No se puede borrar", "El producto tiene ventas registradas.")
        }
    }

    @IBAction func agregarProducto(_ sender: UIBarButtonItem) {
        formulario(nil)
    }

    func formulario(_ producto: Producto?) {
        let alerta = UIAlertController(title: producto == nil ? "Nuevo producto" : "Editar producto",
                                       message: "Nombre, categoría, precio y stock", preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = producto?.nombre }
        alerta.addTextField { $0.placeholder = "Categoría"; $0.text = producto?.categoria }
        alerta.addTextField {
            $0.placeholder = "Precio"
            $0.keyboardType = .decimalPad
            $0.text = producto.map { String(format: "%.2f", $0.precio) }
        }
        alerta.addTextField {
            $0.placeholder = "Stock"
            $0.keyboardType = .numberPad
            $0.text = producto.map { "\($0.stock)" }
        }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            let campos = alerta.textFields ?? []
            let nombre = (campos[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let categoria = (campos[1].text ?? "").trimmingCharacters(in: .whitespaces)
            let precio = Double((campos[2].text ?? "").replacingOccurrences(of: ",", with: "."))
            let stock = Int64(campos[3].text ?? "")
            guard !nombre.isEmpty, !categoria.isEmpty, let precio, precio > 0, let stock, stock >= 0 else {
                self?.avisar("Datos no válidos", "Completa el nombre y la categoría, un precio mayor que cero y un stock mayor o igual a cero.")
                return
            }
            let editado = producto ?? Producto(context: Datos.contexto)
            editado.nombre = nombre
            editado.categoria = categoria
            editado.precio = Datos.redondear(precio)
            editado.stock = stock
            if Datos.guardar() {
                self?.cargar()
            }
        })
        present(alerta, animated: true)
    }
}

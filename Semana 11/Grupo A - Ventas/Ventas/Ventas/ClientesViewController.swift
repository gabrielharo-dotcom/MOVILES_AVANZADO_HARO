//
//  ClientesViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class ClientesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var buscador: UISearchBar!

    var clientes = [Cliente]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.dataSource = self
        tabla.delegate = self
        buscador.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    func cargar() {
        let request: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        let texto = (buscador.text ?? "").trimmingCharacters(in: .whitespaces)
        if !texto.isEmpty {
            request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        clientes = (try? Datos.contexto.fetch(request)) ?? []
        tabla.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clientes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "fila", for: indexPath) as! FilaCell
        let cliente = clientes[indexPath.row]
        let documento = cliente.documento ?? ""
        let tipo = documento.count == 11 ? "RUC" : "DNI"
        let categoria = Datos.categoria(cliente)
        celda.configurar(iniciales: Datos.iniciales(cliente.nombre),
                         color: Estilo.color(para: cliente.nombre),
                         titulo: cliente.nombre ?? "",
                         subtitulo: "\(tipo) \(documento)",
                         monto: Datos.soles(Datos.totalComprado(cliente)),
                         etiqueta: categoria,
                         colorEtiqueta: Estilo.colorCategoria(categoria))
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        formulario(clientes[indexPath.row])
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
        let cliente = clientes[indexPath.row]
        if (cliente.ventas?.count ?? 0) > 0 {
            avisar("No se puede borrar", "\(cliente.nombre ?? "El cliente") tiene ventas registradas.")
            return
        }
        Datos.contexto.delete(cliente)
        if Datos.guardar() {
            cargar()
        } else {
            avisar("No se puede borrar", "El cliente tiene ventas registradas.")
        }
    }

    @IBAction func agregarCliente(_ sender: UIBarButtonItem) {
        formulario(nil)
    }

    func formulario(_ cliente: Cliente?) {
        let alerta = UIAlertController(title: cliente == nil ? "Nuevo cliente" : "Editar cliente",
                                       message: "Nombre y documento (DNI de 8 dígitos o RUC de 11)", preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = cliente?.nombre }
        alerta.addTextField {
            $0.placeholder = "Documento"
            $0.keyboardType = .numberPad
            $0.text = cliente?.documento
        }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            let campos = alerta.textFields ?? []
            let nombre = (campos[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let documento = (campos[1].text ?? "").trimmingCharacters(in: .whitespaces)
            guard !nombre.isEmpty, documento.count == 8 || documento.count == 11, Int(documento) != nil else {
                self?.avisar("Datos no válidos", "Completa el nombre y un documento de 8 u 11 dígitos.")
                return
            }
            let editado = cliente ?? Cliente(context: Datos.contexto)
            editado.nombre = nombre
            editado.documento = documento
            if Datos.guardar() {
                self?.cargar()
            }
        })
        present(alerta, animated: true)
    }
}

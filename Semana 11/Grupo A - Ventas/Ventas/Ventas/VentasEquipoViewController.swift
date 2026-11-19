//
//  VentasEquipoViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class VentasEquipoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var segPeriodo: UISegmentedControl!
    @IBOutlet weak var stackChips: UIStackView!
    @IBOutlet weak var buscador: UISearchBar!
    @IBOutlet weak var tabla: UITableView!

    var ventas = [Venta]()
    var vendedores = [Usuario]()
    var vendedorElegido = 0

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
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "rol == %@", "Vendedor")
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        vendedores = (try? Datos.contexto.fetch(request)) ?? []
        if vendedorElegido > vendedores.count {
            vendedorElegido = 0
        }
        let nombres = vendedores.map { $0.nombre ?? "" }
        Estilo.llenarChips(stackChips, titulos: ["Todos"] + nombres, seleccionado: vendedorElegido) { [weak self] indice in
            self?.vendedorElegido = indice
            self?.cargar()
        }

        var condiciones = [NSPredicate]()
        if let periodo = Datos.predicadoPeriodo(segPeriodo.selectedSegmentIndex) {
            condiciones.append(periodo)
        }
        if vendedorElegido > 0 {
            condiciones.append(NSPredicate(format: "vendedor == %@", vendedores[vendedorElegido - 1]))
        }
        let texto = (buscador.text ?? "").trimmingCharacters(in: .whitespaces)
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", texto))
        }
        ventas = Datos.ventas(condiciones)
        tabla.reloadData()
    }

    @IBAction func periodoCambio(_ sender: UISegmentedControl) {
        cargar()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "fila", for: indexPath) as! FilaCell
        let venta = ventas[indexPath.row]
        let vendedor = Datos.primerNombre(venta.vendedor?.nombre)
        let detalle = venta.anulada
            ? "\(vendedor) · Motivo: \(venta.motivoAnulacion ?? "")"
            : "\(vendedor) · \(venta.producto?.nombre ?? "") × \(venta.cantidad)"
        celda.configurar(iniciales: Datos.iniciales(venta.cliente?.nombre),
                         color: Estilo.color(para: venta.cliente?.nombre),
                         titulo: venta.cliente?.nombre ?? "",
                         subtitulo: detalle,
                         monto: Datos.soles(venta.total),
                         etiqueta: venta.anulada ? "Anulada" : "",
                         colorEtiqueta: .systemRed,
                         tachado: venta.anulada)
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard Sesion.shared.esSupervisor, !venta.anulada else { return nil }
        let anular = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _, _, terminado in
            self?.anular(venta)
            terminado(true)
        }
        return UISwipeActionsConfiguration(actions: [anular])
    }

    func anular(_ venta: Venta) {
        let resumen = "\(venta.cliente?.nombre ?? "") · \(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(Datos.soles(venta.total))"
        let alerta = UIAlertController(title: "Anular venta",
                                       message: "\(resumen)\nEl stock se devolverá (+\(venta.cantidad)).",
                                       preferredStyle: .alert)
        let accionAnular = UIAlertAction(title: "Anular", style: .destructive) { [weak self] _ in
            let motivo = (alerta.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespaces)
            guard !motivo.isEmpty else { return }
            venta.anulada = true
            venta.motivoAnulacion = motivo
            venta.producto?.stock += venta.cantidad
            if Datos.guardar() {
                self?.cargar()
            } else {
                self?.avisar("Error", "No se pudo anular la venta.")
            }
        }
        accionAnular.isEnabled = false

        alerta.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"
            campo.addAction(UIAction { _ in
                accionAnular.isEnabled = !(campo.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
            }, for: .editingChanged)
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(accionAnular)
        present(alerta, animated: true)
    }
}

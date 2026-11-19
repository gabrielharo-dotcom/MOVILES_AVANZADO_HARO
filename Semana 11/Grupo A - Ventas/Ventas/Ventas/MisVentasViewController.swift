//
//  MisVentasViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class MisVentasViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var lblHoy: UILabel!
    @IBOutlet weak var lblHoyCantidad: UILabel!
    @IBOutlet weak var lblMes: UILabel!
    @IBOutlet weak var lblMesCantidad: UILabel!
    @IBOutlet weak var segPeriodo: UISegmentedControl!
    @IBOutlet weak var buscador: UISearchBar!
    @IBOutlet weak var tabla: UITableView!

    var ventas = [Venta]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.dataSource = self
        tabla.allowsSelection = false
        buscador.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    func cargar() {
        guard let usuario = Sesion.shared.usuario else { return }
        let propias = NSPredicate(format: "vendedor == %@", usuario)
        let validas = NSPredicate(format: "anulada == NO")

        let deHoy = Datos.ventas([propias, validas, Datos.predicadoPeriodo(1)!])
        lblHoy.text = Datos.soles(Datos.total(deHoy))
        lblHoyCantidad.text = "\(deHoy.count) ventas"
        let delMes = Datos.ventas([propias, validas, Datos.predicadoPeriodo(2)!])
        lblMes.text = Datos.soles(Datos.total(delMes))
        lblMesCantidad.text = "\(delMes.count) ventas"

        var condiciones = [propias]
        if let periodo = Datos.predicadoPeriodo(segPeriodo.selectedSegmentIndex) {
            condiciones.append(periodo)
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
        celda.configurar(iniciales: venta.anulada ? "✕" : "✓",
                         color: venta.anulada ? .systemRed : .systemGreen,
                         titulo: venta.cliente?.nombre ?? "",
                         subtitulo: "\(Datos.fechaCorta(venta.fecha)) · \(venta.producto?.nombre ?? "") × \(venta.cantidad)",
                         monto: Datos.soles(venta.total),
                         etiqueta: venta.anulada ? "Anulada" : "",
                         colorEtiqueta: .systemRed,
                         tachado: venta.anulada)
        return celda
    }
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let culturas = Cultura.ejemplos

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "culturaCell", for: indexPath) as! CulturaTableViewCell
        let cultura = culturas[indexPath.row]
        cell.nombreCultura.text = cultura.nombre
        cell.regionCultura.text = cultura.region
        cell.imagenCultura.image = UIImage(named: cultura.imagen)
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let seleccion = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: seleccion, animated: true)
        }
    }

    // El segue Show sale de la celda seleccionada en Main.storyboard.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "mostrarDetalleCultura",
              let detalle = segue.destination as? DetalleCulturaViewController,
              let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        detalle.cultura = culturas[indexPath.row]
    }
}

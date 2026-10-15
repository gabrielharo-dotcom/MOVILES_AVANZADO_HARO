import UIKit

class DetalleCulturaViewController: UIViewController {
    var cultura: Cultura?

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cultura = cultura else { return }
        title = cultura.nombre
        nombreLabel.text = "Cultura " + cultura.nombre
        regionLabel.text = "Región: " + cultura.region
        descripcionLabel.text = cultura.descripcion
        imagenView.image = UIImage(named: cultura.imagen)
        imagenView.isAccessibilityElement = true
        imagenView.accessibilityLabel = "Imagen representativa de la cultura " + cultura.nombre
    }
}

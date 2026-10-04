import UIKit

final class ViewControllerConfirmacion: UIViewController {
    var cliente: ClienteModel!

    @IBOutlet private weak var apellidoLabel: UILabel!
    @IBOutlet private weak var nombreLabel: UILabel!
    @IBOutlet private weak var dniLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        apellidoLabel.text = cliente.apellido
        nombreLabel.text = cliente.nombre
        dniLabel.text = cliente.dni
    }

    @IBAction private func volver(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var apellidoTextField: UITextField!
    @IBOutlet private weak var nombreTextField: UITextField!
    @IBOutlet private weak var dniTextField: UITextField!

    @IBAction private func btnContinuar(_ sender: UIButton) {
        view.endEditing(true)
    }
}

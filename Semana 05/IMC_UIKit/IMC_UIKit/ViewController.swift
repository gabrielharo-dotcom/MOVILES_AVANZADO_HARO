import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "Introduce tu peso y altura"
    }

    @IBAction private func calcularResultado(_ sender: UIButton) {
        resultLabel.text = "Cálculo pendiente"
    }
}

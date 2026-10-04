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
        guard let weight = number(from: weightTextField.text),
              let height = number(from: heightTextField.text),
              weight > 0, height > 0 else {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        let bmi = weight / (height * height)
        guard bmi.isFinite else {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        let status: String
        switch bmi {
        case ..<18.5: status = "Bajo peso"
        case ..<25: status = "Peso normal"
        case ..<30: status = "Sobrepeso"
        default: status = "Obesidad"
        }

        resultLabel.text = String(format: "IMC: %.2f - %@", bmi, status)
        view.endEditing(true)
    }

    private func number(from text: String?) -> Double? {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return nil }
        return Double(text.replacingOccurrences(of: ",", with: "."))
    }
}

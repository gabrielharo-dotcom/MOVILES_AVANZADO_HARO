import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var capitalTextField: UITextField!
    @IBOutlet private weak var annualRateTextField: UITextField!
    @IBOutlet private weak var yearsTextField: UITextField!
    @IBOutlet private weak var monthlyPaymentLabel: UILabel!
    @IBOutlet private weak var totalPaymentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissKeyboard))
        ]
        for field in [capitalTextField, annualRateTextField, yearsTextField] {
            field?.inputAccessoryView = toolbar
        }
    }

    @IBAction private func calcularPrestamo(_ sender: UIButton) {
        view.endEditing(true)

        guard let principal = number(from: capitalTextField.text),
              let annualRate = number(from: annualRateTextField.text),
              let yearsText = yearsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let years = Int(yearsText),
              let result = LoanCalculator.calculate(
                principal: principal,
                annualRatePercent: annualRate,
                years: years
              ) else {
            monthlyPaymentLabel.text = "Revisa los datos ingresados."
            totalPaymentLabel.text = "Total a pagar: —"
            return
        }

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_PE")
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        guard let monthly = formatter.string(from: NSNumber(value: result.monthlyPayment)),
              let total = formatter.string(from: NSNumber(value: result.totalPayment)) else {
            monthlyPaymentLabel.text = "No se pudo mostrar el resultado."
            totalPaymentLabel.text = "Total a pagar: —"
            return
        }

        monthlyPaymentLabel.text = "Cuota mensual: \(monthly)"
        totalPaymentLabel.text = "Total a pagar: \(total)"
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func number(from text: String?) -> Double? {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return nil }
        return Double(text.replacingOccurrences(of: ",", with: "."))
    }
}

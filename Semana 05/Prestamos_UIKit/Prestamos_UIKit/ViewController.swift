import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var capitalTextField: UITextField!
    @IBOutlet private weak var annualRateTextField: UITextField!
    @IBOutlet private weak var yearsTextField: UITextField!
    @IBOutlet private weak var monthlyPaymentLabel: UILabel!
    @IBOutlet private weak var totalPaymentLabel: UILabel!

    @IBAction private func calcularPrestamo(_ sender: UIButton) {
        view.endEditing(true)
    }
}

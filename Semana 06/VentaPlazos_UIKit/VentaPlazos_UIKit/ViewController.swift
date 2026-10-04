import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var electrodomesticoTextField: UITextField!
    @IBOutlet private weak var precioTextField: UITextField!
    @IBOutlet private weak var cantidadTextField: UITextField!
    @IBOutlet private weak var mesesTextField: UITextField!
    @IBOutlet private weak var tasaTextField: UITextField!

    private var venta: VentaModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissKeyboard))
        ]
        for field in [precioTextField, cantidadTextField, mesesTextField, tasaTextField] {
            field?.inputAccessoryView = toolbar
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "showResultado" else { return true }
        view.endEditing(true)

        let nombre = electrodomesticoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let precioTexto = precioTextField.text?.replacingOccurrences(of: ",", with: ".") ?? ""
        let tasaTexto = tasaTextField.text?.replacingOccurrences(of: ",", with: ".") ?? ""
        guard !nombre.isEmpty,
              let precioUnitario = Double(precioTexto), precioUnitario.isFinite, precioUnitario > 0,
              let cantidad = Int(cantidadTextField.text ?? ""), cantidad > 0,
              let meses = Int(mesesTextField.text ?? ""), meses > 0,
              let tasaInteresMensual = Double(tasaTexto), tasaInteresMensual.isFinite,
              tasaInteresMensual >= 0 else {
            mostrarAviso()
            return false
        }

        let subtotal = precioUnitario * Double(cantidad)
        let igv = subtotal * 0.18
        let base = subtotal + igv
        let intereses = base * (tasaInteresMensual / 100) * Double(meses)
        let total = base + intereses
        let cuota = total / Double(meses)
        guard [subtotal, igv, base, intereses, total, cuota].allSatisfy(\.isFinite) else {
            mostrarAviso()
            return false
        }

        venta = VentaModel(subtotal: subtotal, igv: igv, base: base,
                           intereses: intereses, total: total, cuota: cuota)
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showResultado",
              let resultado = segue.destination as? ResultadoViewController else { return }
        resultado.venta = venta
    }

    private func mostrarAviso() {
        let alert = UIAlertController(
            title: "Revisa los datos",
            message: "Completa el electrodoméstico, precio y tasa válidos; cantidad y meses deben ser mayores que cero.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

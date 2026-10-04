import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var apellidoTextField: UITextField!
    @IBOutlet private weak var nombreTextField: UITextField!
    @IBOutlet private weak var dniTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissKeyboard))
        ]
        dniTextField.inputAccessoryView = toolbar
    }

    @IBAction private func btnContinuar(_ sender: UIButton) {
        view.endEditing(true)

        let apellido = apellidoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let nombre = nombreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dni = dniTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !apellido.isEmpty, !nombre.isEmpty,
              dni.count == 8, dni.allSatisfy(\.isNumber) else {
            let alert = UIAlertController(
                title: "Revisa los datos",
                message: "Ingresa apellidos, nombres y un DNI de 8 dígitos.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alert, animated: true)
            return
        }

        let cliente = ClienteModel(apellido: apellido, nombre: nombre, dni: dni)
        guard let confirmacion = storyboard?.instantiateViewController(
            withIdentifier: "ViewControllerConfirmacion"
        ) as? ViewControllerConfirmacion else { return }
        confirmacion.cliente = cliente
        confirmacion.modalPresentationStyle = .pageSheet
        present(confirmacion, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

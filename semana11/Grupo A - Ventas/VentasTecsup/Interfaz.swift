import UIKit

extension UITextField {
    var textoLimpio: String {
        (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func etiqueta(_ texto: String, estilo: UIFont.TextStyle = .body, color: UIColor = .label) -> UILabel {
    let vista = UILabel()
    vista.text = texto
    vista.font = .preferredFont(forTextStyle: estilo)
    vista.adjustsFontForContentSizeCategory = true
    vista.numberOfLines = 0
    vista.textColor = color
    return vista
}

func boton(_ titulo: String, principal: Bool = true, accion: @escaping () -> Void) -> UIButton {
    var configuracion = principal ? UIButton.Configuration.filled() : .tinted()
    configuracion.title = titulo
    configuracion.cornerStyle = .medium
    let boton = UIButton(configuration: configuracion, primaryAction: UIAction { _ in accion() })
    boton.heightAnchor.constraint(greaterThanOrEqualToConstant: 46).isActive = true
    return boton
}

func campo(_ titulo: String, secreto: Bool = false) -> UITextField {
    let campo = UITextField()
    campo.placeholder = titulo
    campo.accessibilityLabel = titulo
    campo.borderStyle = .roundedRect
    campo.font = .preferredFont(forTextStyle: .body)
    campo.adjustsFontForContentSizeCategory = true
    campo.isSecureTextEntry = secreto
    campo.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    return campo
}

extension UIViewController {
    func avisar(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}

class Formulario: UIViewController {
    let contenido = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        let desplazamiento = UIScrollView()
        desplazamiento.keyboardDismissMode = .interactive
        desplazamiento.translatesAutoresizingMaskIntoConstraints = false
        contenido.translatesAutoresizingMaskIntoConstraints = false
        contenido.axis = .vertical
        contenido.spacing = 14
        view.addSubview(desplazamiento)
        desplazamiento.addSubview(contenido)
        let seguro = view.safeAreaLayoutGuide
        let guia = desplazamiento.contentLayoutGuide
        NSLayoutConstraint.activate([
            desplazamiento.topAnchor.constraint(equalTo: seguro.topAnchor),
            desplazamiento.leadingAnchor.constraint(equalTo: seguro.leadingAnchor),
            desplazamiento.trailingAnchor.constraint(equalTo: seguro.trailingAnchor),
            desplazamiento.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            contenido.topAnchor.constraint(equalTo: guia.topAnchor, constant: 20),
            contenido.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 20),
            contenido.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -20),
            contenido.bottomAnchor.constraint(equalTo: guia.bottomAnchor, constant: -20),
            contenido.widthAnchor.constraint(equalTo: desplazamiento.frameLayoutGuide.widthAnchor, constant: -40),
        ])
    }
}

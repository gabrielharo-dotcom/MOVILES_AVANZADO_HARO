import UIKit

final class IngresoViewController: Formulario {
    private let almacen: Almacen
    private let alIngresar: () -> Void
    private let usuario = campo("Usuario")
    private let clave = campo("Clave", secreto: true)
    private let error = etiqueta("", estilo: .footnote, color: .systemRed)

    init(almacen: Almacen, alIngresar: @escaping () -> Void) {
        self.almacen = almacen
        self.alIngresar = alIngresar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImageView(image: UIImage(systemName: "cart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .semibold)))
        logo.contentMode = .center
        logo.tintColor = .systemBlue
        logo.heightAnchor.constraint(equalToConstant: 72).isActive = true
        let titulo = etiqueta("Ventas Tecsup", estilo: .largeTitle)
        titulo.textAlignment = .center
        let indicacion = etiqueta("Inicia sesión para continuar", estilo: .subheadline, color: .secondaryLabel)
        indicacion.textAlignment = .center
        usuario.autocapitalizationType = .none
        usuario.autocorrectionType = .no
        usuario.textContentType = .username
        clave.textContentType = .password
        error.isHidden = true

        for vista in [logo, titulo, indicacion, usuario, clave, error] as [UIView] {
            contenido.addArrangedSubview(vista)
        }
        contenido.setCustomSpacing(26, after: indicacion)
        contenido.addArrangedSubview(boton("Ingresar") { [weak self] in self?.ingresar() })
        contenido.addArrangedSubview(boton("Crear cuenta", principal: false) { [weak self] in
            guard let self else { return }
            navigationController?.pushViewController(
                RegistroViewController(almacen: almacen, alRegistrar: alIngresar), animated: true
            )
        })
    }

    private func ingresar() {
        view.endEditing(true)
        do {
            try almacen.ingresar(usuario: usuario.textoLimpio, clave: clave.text ?? "")
            alIngresar()
        } catch {
            self.error.text = error.localizedDescription
            self.error.isHidden = false
            UIAccessibility.post(notification: .announcement, argument: self.error.text)
        }
    }
}

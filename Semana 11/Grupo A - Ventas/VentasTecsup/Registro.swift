import UIKit

final class RegistroViewController: Formulario {
    private let almacen: Almacen
    private let alRegistrar: () -> Void
    private let nombre = campo("Nombre completo")
    private let usuario = campo("Usuario")
    private let clave = campo("Clave (mínimo 6 caracteres)", secreto: true)
    private let confirmacion = campo("Confirmar clave", secreto: true)
    private let roles = UISegmentedControl(items: Rol.allCases.map(\.rawValue))
    private let disponibilidad = etiqueta("", estilo: .footnote)

    init(almacen: Almacen, alRegistrar: @escaping () -> Void) {
        self.almacen = almacen
        self.alRegistrar = alRegistrar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        nombre.textContentType = .name
        usuario.textContentType = .username
        usuario.autocapitalizationType = .none
        usuario.autocorrectionType = .no
        clave.textContentType = .newPassword
        confirmacion.textContentType = .newPassword
        roles.selectedSegmentIndex = 0
        roles.accessibilityLabel = "Rol"
        usuario.addAction(UIAction { [weak self] _ in self?.revisarUsuario() }, for: .editingChanged)
        for vista in [nombre, usuario, disponibilidad, clave, confirmacion, etiqueta("Tu rol", estilo: .headline), roles] as [UIView] {
            contenido.addArrangedSubview(vista)
        }
        disponibilidad.isHidden = true
        contenido.addArrangedSubview(boton("Registrarme") { [weak self] in self?.registrar() })
    }

    private func revisarUsuario() {
        disponibilidad.isHidden = usuario.textoLimpio.isEmpty
        guard !disponibilidad.isHidden else { return }
        do {
            let existe = try almacen.buscarUsuario(usuario.textoLimpio) != nil
            disponibilidad.text = existe ? "El usuario ya existe" : "Usuario disponible"
            disponibilidad.textColor = existe ? .systemRed : .systemGreen
        } catch {
            disponibilidad.isHidden = true
        }
    }

    private func registrar() {
        view.endEditing(true)
        do {
            try almacen.registrar(nombre: nombre.textoLimpio, usuario: usuario.textoLimpio,
                                   clave: clave.text ?? "", confirmacion: confirmacion.text ?? "",
                                   rol: Rol.allCases[roles.selectedSegmentIndex])
            alRegistrar()
        } catch {
            avisar("No se pudo crear la cuenta", error.localizedDescription)
        }
    }
}

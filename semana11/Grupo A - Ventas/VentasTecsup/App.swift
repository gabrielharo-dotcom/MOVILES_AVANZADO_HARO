import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let almacen = Almacen()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let escena = scene as? UIWindowScene else { return }
        let ventana = UIWindow(windowScene: escena)
        window = ventana
        ventana.rootViewController = UIViewController()
        ventana.makeKeyAndVisible()
        almacen.contenedor.loadPersistentStores { [weak self] _, error in
            DispatchQueue.main.async {
                guard let self else { return }
                if let error {
                    self.mostrarError(error.localizedDescription)
                } else {
                    self.mostrarIngreso()
                }
            }
        }
    }

    private func mostrarError(_ mensaje: String) {
        let controlador = UIViewController()
        controlador.view.backgroundColor = .systemBackground
        let texto = UILabel()
        texto.text = "No pude abrir Core Data: " + mensaje
        texto.numberOfLines = 0
        texto.translatesAutoresizingMaskIntoConstraints = false
        controlador.view.addSubview(texto)
        NSLayoutConstraint.activate([
            texto.leadingAnchor.constraint(equalTo: controlador.view.leadingAnchor, constant: 24),
            texto.trailingAnchor.constraint(equalTo: controlador.view.trailingAnchor, constant: -24),
            texto.centerYAnchor.constraint(equalTo: controlador.view.centerYAnchor)
        ])
        window?.rootViewController = controlador
    }

    private func mostrarIngreso() {
        window?.rootViewController = UINavigationController(rootViewController: AccesoBaseViewController(almacen: almacen) { [weak self] in self?.mostrarProductos() })
    }

    private func mostrarProductos() {
        window?.rootViewController = UINavigationController(rootViewController: ProductosBaseViewController(almacen: almacen) { [weak self] in
            self?.almacen.cerrarSesion()
            self?.mostrarIngreso()
        })
    }
}

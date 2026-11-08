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
        let espera = Formulario()
        espera.loadViewIfNeeded()
        espera.contenido.addArrangedSubview(etiqueta("Abriendo Ventas Tecsup…"))
        ventana.rootViewController = espera
        ventana.makeKeyAndVisible()

        almacen.contenedor.loadPersistentStores { [weak self, weak espera] _, error in
            DispatchQueue.main.async {
                if error != nil {
                    espera?.avisar("No se pudo abrir Ventas", "Cierra la app y vuelve a intentarlo.")
                } else {
                    self?.mostrarIngreso()
                }
            }
        }
    }

    private func mostrarIngreso() {
        let ingreso = IngresoViewController(almacen: almacen) { [weak self] in
            self?.mostrarSesion()
        }
        window?.rootViewController = UINavigationController(rootViewController: ingreso)
    }

    private func mostrarSesion() {
        guard let cuenta = almacen.usuarioActual else { return }
        let pantalla = Formulario()
        pantalla.title = "Cuenta"
        pantalla.loadViewIfNeeded()
        pantalla.contenido.addArrangedSubview(etiqueta(cuenta.nombre, estilo: .title2))
        pantalla.contenido.addArrangedSubview(etiqueta(cuenta.usuario, color: .secondaryLabel))
        pantalla.contenido.addArrangedSubview(etiqueta(cuenta.rol, estilo: .headline))
        pantalla.contenido.addArrangedSubview(boton("Cerrar sesión", principal: false) { [weak self] in
            self?.almacen.cerrarSesion()
            self?.mostrarIngreso()
        })
        let pestanas = UITabBarController()
        let productos = ProductosViewController(almacen: almacen, supervisor: cuenta.esSupervisor)
        let clientes = ClientesViewController(almacen: almacen, supervisor: cuenta.esSupervisor)
        var pantallas = [
            pestana(productos, "Productos", "shippingbox"),
            pestana(clientes, "Clientes", "person.2"),
        ]
        if !cuenta.esSupervisor {
            pantallas.append(pestana(NuevaVentaViewController(almacen: almacen, vendedor: cuenta), "Venta", "cart.badge.plus"))
        }
        pantallas.append(pestana(pantalla, "Cuenta", "person.crop.circle"))
        pestanas.viewControllers = pantallas
        window?.rootViewController = pestanas
    }

    private func pestana(_ pantalla: UIViewController, _ titulo: String, _ icono: String) -> UIViewController {
        let navegacion = UINavigationController(rootViewController: pantalla)
        navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        return navegacion
    }
}

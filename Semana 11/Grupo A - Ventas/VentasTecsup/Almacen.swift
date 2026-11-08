import CoreData

struct ErrorVentas: LocalizedError {
    let errorDescription: String?

    init(_ mensaje: String) {
        errorDescription = mensaje
    }
}

final class Almacen {
    let contenedor = NSPersistentContainer(name: "Ventas")
    private(set) var usuarioActual: Usuario?

    var contexto: NSManagedObjectContext { contenedor.viewContext }

    func buscar<T: NSManagedObject>(
        _ tipo: T.Type,
        donde predicado: NSPredicate? = nil,
        orden: [NSSortDescriptor] = [],
        limite: Int = 0
    ) throws -> [T] {
        let consulta = NSFetchRequest<T>(entityName: String(describing: tipo))
        consulta.predicate = predicado
        consulta.sortDescriptors = orden
        consulta.fetchLimit = limite
        return try contexto.fetch(consulta)
    }

    func guardar() throws {
        do {
            try contexto.save()
        } catch {
            contexto.rollback()
            throw ErrorVentas("No se pudieron guardar los cambios. Inténtalo de nuevo.")
        }
    }

    static func normalizarUsuario(_ texto: String) -> String {
        texto.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func buscarUsuario(_ texto: String) throws -> Usuario? {
        try buscar(Usuario.self, donde: NSPredicate(
            format: "usuario == %@", Self.normalizarUsuario(texto)
        ), limite: 1).first
    }

    func ingresar(usuario: String, clave: String) throws {
        guard let cuenta = try buscarUsuario(usuario), cuenta.clave == clave else {
            throw ErrorVentas("Usuario o clave incorrectos")
        }
        usuarioActual = cuenta
    }

    func cerrarSesion() {
        usuarioActual = nil
    }

    func registrar(nombre: String, usuario: String, clave: String, confirmacion: String, rol: Rol) throws {
        guard !nombre.isEmpty, !Self.normalizarUsuario(usuario).isEmpty else {
            throw ErrorVentas("Completa el nombre y el usuario.")
        }
        guard clave.count >= 6 else { throw ErrorVentas("La clave debe tener al menos 6 caracteres.") }
        guard clave == confirmacion else { throw ErrorVentas("Las claves deben coincidir.") }
        guard try buscarUsuario(usuario) == nil else { throw ErrorVentas("El usuario ya existe.") }
        let cuenta = Usuario(context: contexto)
        cuenta.nombre = nombre
        cuenta.usuario = Self.normalizarUsuario(usuario)
        cuenta.clave = clave
        cuenta.rol = rol.rawValue
        try guardar()
        usuarioActual = cuenta
    }
}

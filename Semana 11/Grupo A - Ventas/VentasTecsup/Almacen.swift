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
}

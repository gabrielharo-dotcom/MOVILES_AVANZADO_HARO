import Foundation

final class ClienteModel: NSObject {
    let codigo: Int32
    let apellido: String
    let nombre: String
    let dni: String

    init(codigo: Int32 = 0, apellido: String, nombre: String, dni: String) {
        self.codigo = codigo
        self.apellido = apellido
        self.nombre = nombre
        self.dni = dni
    }
}

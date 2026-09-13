// Desarrollado por: Gabriel Haro
// Laboratorio 04 - Caso 2A: Biblioteca sin IA

import Foundation

// El enum limita el estado de un libro a las dos opciones del enunciado.
enum EstadoLibro {
    case disponible, prestado
}

// Libro es struct porque representa un dato que puede copiarse y actualizarse.
struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro = .disponible
}

// Biblioteca es class para mantener un único inventario compartido.
class Biblioteca {
    var libros: [Libro] = []

    // Añade un libro nuevo al final del inventario.
    func agregar(libro: Libro) {
        libros.append(libro)
    }

    // Busca por índice para modificar directamente el struct dentro del array.
    func prestar(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                }

                print("Error: \(titulo) ya está prestado")
                return false
            }
        }

        print("Error: no existe \(titulo)")
        return false
    }

    // Realiza la operación inversa y vuelve a dejar disponible el libro.
    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                }

                print("Error: \(titulo) ya está disponible")
                return false
            }
        }

        print("Error: no existe \(titulo)")
        return false
    }

    // Usa switch para convertir cada estado en el texto solicitado.
    func inventario() {
        print("===== INVENTARIO =====")
        for libro in libros {
            switch libro.estado {
            case .disponible:
                print("\(libro.titulo) (\(libro.autor)) - disponible")
            case .prestado:
                print("\(libro.titulo) (\(libro.autor)) - prestado")
            }
        }
    }
}

// Simulación pedida en la guía.
let biblioteca = Biblioteca()
biblioteca.agregar(libro: Libro(
    titulo: "Cien años de soledad",
    autor: "Gabriel García Márquez"
))
biblioteca.agregar(libro: Libro(
    titulo: "La ciudad y los perros",
    autor: "Mario Vargas Llosa"
))
biblioteca.agregar(libro: Libro(
    titulo: "El Quijote",
    autor: "Miguel de Cervantes"
))

_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.devolver(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "El Quijote")
_ = biblioteca.prestar(titulo: "El Principito")
biblioteca.inventario()

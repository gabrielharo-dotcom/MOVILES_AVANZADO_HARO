// Desarrollado por: Gabriel Haro
// Laboratorio 04 - Caso 2B: Biblioteca con apoyo de IA

enum EstadoLibro { // Agrupa los dos estados permitidos para cualquier libro.
    case disponible // Indica que el libro se puede prestar.
    case prestado // Indica que el libro ya salio de la biblioteca.
} // Finaliza la declaracion de los estados.

struct Libro { // Representa cada libro como un dato independiente.
    let titulo: String // Guarda el titulo usado en las busquedas.
    let autor: String // Guarda el nombre del autor para el inventario.
    var estado: EstadoLibro // Permite actualizar el estado al prestar o devolver.

    init(titulo: String, autor: String) { // Recibe los datos necesarios para crear un libro.
        self.titulo = titulo // Asigna el titulo recibido al nuevo libro.
        self.autor = autor // Asigna el autor recibido al nuevo libro.
        self.estado = .disponible // Todo libro nuevo comienza disponible.
    } // Finaliza la inicializacion del libro.
} // Finaliza la estructura Libro.

class Biblioteca { // Mantiene una sola coleccion compartida de libros.
    var libros: [Libro] = [] // Empieza con un inventario vacio.

    func agregar(libro: Libro) { // Recibe un libro para registrarlo.
        libros.append(libro) // Añade el libro al final del inventario.
    } // Finaliza el registro del libro.

    func prestar(titulo: String) -> Bool { // Busca y presta un libro por su titulo.
        for i in 0..<libros.count { // Recorre los indices validos del inventario.
            if libros[i].titulo == titulo { // Comprueba si el titulo actual es el solicitado.
                if libros[i].estado == .disponible { // Verifica que el ejemplar pueda prestarse.
                    libros[i].estado = .prestado // Modifica el struct directamente dentro del array.
                    print("Préstamo aprobado: \(titulo)") // Informa que el prestamo fue realizado.
                    return true // Confirma que la operacion termino correctamente.
                } else { // Se ejecuta cuando el libro encontrado ya fue prestado.
                    print("Error: \(titulo) ya está prestado") // Explica por que no se puede repetir el prestamo.
                    return false // Indica que no hubo ningun cambio.
                } // Finaliza la revision del estado del libro.
            } // Finaliza la comparacion del titulo actual.
        } // Finaliza el recorrido del inventario.
        print("Error: no existe \(titulo)") // Informa que ningun libro coincide con el titulo.
        return false // Indica que el prestamo no se pudo realizar.
    } // Finaliza el metodo prestar.

    func devolver(titulo: String) -> Bool { // Busca y devuelve un libro por su titulo.
        for i in 0..<libros.count { // Recorre el inventario usando indices.
            if libros[i].titulo == titulo { // Detecta el libro que se desea devolver.
                if libros[i].estado == .prestado { // Comprueba que el libro realmente este prestado.
                    libros[i].estado = .disponible // Cambia el estado del elemento guardado en el array.
                    print("Devolución registrada: \(titulo)") // Confirma la devolucion al usuario.
                    return true // Indica que la devolucion fue exitosa.
                } else { // Se ejecuta si el libro ya se encontraba disponible.
                    print("Error: \(titulo) ya está disponible") // Explica que no necesita devolverse.
                    return false // Informa que la operacion no produjo cambios.
                } // Finaliza la revision del estado para la devolucion.
            } // Finaliza la comparacion del titulo.
        } // Finaliza la busqueda por indice.
        print("Error: no existe \(titulo)") // Informa que el titulo no pertenece al inventario.
        return false // Indica que la devolucion no se pudo completar.
    } // Finaliza el metodo devolver.

    func inventario() { // Muestra todos los libros y su estado actual.
        print("===== INVENTARIO =====") // Imprime el encabezado solicitado.
        for libro in libros { // Recorre cada libro almacenado.
            switch libro.estado { // Selecciona el texto correspondiente a su estado.
            case .disponible: // Atiende los libros que pueden prestarse.
                print("\(libro.titulo) (\(libro.autor)) - disponible") // Muestra los datos y el estado disponible.
            case .prestado: // Atiende los libros que ya fueron prestados.
                print("\(libro.titulo) (\(libro.autor)) - prestado") // Muestra los datos y el estado prestado.
            } // Finaliza la seleccion del estado.
        } // Finaliza el recorrido de los libros.
    } // Finaliza el metodo inventario.
} // Finaliza la clase Biblioteca.

let biblioteca = Biblioteca() // Crea la biblioteca usada en la simulacion.
let libroUno = Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez") // Prepara el primer libro solicitado.
let libroDos = Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa") // Prepara el segundo libro solicitado.
let libroTres = Libro(titulo: "El Quijote", autor: "Miguel de Cervantes") // Prepara el tercer libro solicitado.
biblioteca.agregar(libro: libroUno) // Registra el primer libro en el inventario.
biblioteca.agregar(libro: libroDos) // Registra el segundo libro en el inventario.
biblioteca.agregar(libro: libroTres) // Registra el tercer libro en el inventario.
_ = biblioteca.prestar(titulo: "La ciudad y los perros") // Realiza el primer prestamo valido.
_ = biblioteca.prestar(titulo: "La ciudad y los perros") // Comprueba el error por prestamo repetido.
_ = biblioteca.devolver(titulo: "La ciudad y los perros") // Devuelve el libro prestado.
_ = biblioteca.prestar(titulo: "El Quijote") // Deja El Quijote como prestado.
_ = biblioteca.prestar(titulo: "El Principito") // Comprueba el error para un titulo inexistente.
biblioteca.inventario() // Muestra el estado final de los tres libros.

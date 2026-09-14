import Foundation

// Actividad 01: cursos libres de Tecsup.
// Los precios no incluyen IGV. Cada unidad comprada cuenta como un curso.
struct Curso {
    let nombre: String
    let precio: Double
}

struct Inscripcion {
    let curso: Curso
    let cantidad: Int
}

struct Alumno {
    let nombre: String
    let dni: String
    let esTecsup: Bool
}

struct ResumenFactura {
    let cantidadCursos: Int
    let subtotal: Double
    let igv: Double
    let totalConIGV: Double
    let descuentoCantidad: Double
    let descuentoTecsup: Double
    let totalPagar: Double
}


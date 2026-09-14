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

class FacturaCursos {
    let alumno: Alumno
    var inscripciones: [Inscripcion] = []

    init(alumno: Alumno) {
        self.alumno = alumno
    }

    @discardableResult
    func agregar(curso: Curso, cantidad: Int) -> Bool {
        if cantidad <= 0 || curso.precio < 0 {
            return false
        }
        inscripciones.append(Inscripcion(curso: curso, cantidad: cantidad))
        return true
    }

    func calcular() -> ResumenFactura {
        var subtotal = 0.0
        var cantidadCursos = 0
        for inscripcion in inscripciones {
            subtotal += inscripcion.curso.precio * Double(inscripcion.cantidad)
            cantidadCursos += inscripcion.cantidad
        }
        let igv = subtotal * 0.18
        let totalConIGV = subtotal + igv
        var descuentoCantidad = 0.0
        var descuentoTecsup = 0.0
        if cantidadCursos >= 3 {
            descuentoCantidad = totalConIGV * 0.10
            if alumno.esTecsup {
                descuentoTecsup = 400.0
            }
        }
        // El descuento fijo se resta después del 10 %, como en el ejemplo.
        // Se conserva la fórmula literal del enunciado, que no especifica un tope.
        let totalPagar = totalConIGV - descuentoCantidad - descuentoTecsup
        return ResumenFactura(cantidadCursos: cantidadCursos, subtotal: subtotal,
                              igv: igv, totalConIGV: totalConIGV,
                              descuentoCantidad: descuentoCantidad,
                              descuentoTecsup: descuentoTecsup, totalPagar: totalPagar)
    }

    func mostrarFactura() {
        let resumen = calcular()
        print("🎓 FACTURA DE CURSOS")
        print("Estudiante: \(alumno.nombre)")
        print("DNI: \(alumno.dni)")
        if alumno.esTecsup {
            print("Alumno de Tecsup: Sí ✅")
        } else {
            print("Alumno de Tecsup: No")
        }
        print("----------------------------------------")
        for inscripcion in inscripciones {
            let importe = inscripcion.curso.precio * Double(inscripcion.cantidad)
            print("\(inscripcion.curso.nombre) x\(inscripcion.cantidad) - S/ \(moneda(importe))")
        }
        print("----------------------------------------")
        print("Subtotal: S/ \(moneda(resumen.subtotal))")
        print("IGV (18%): S/ \(moneda(resumen.igv))")
        print("Total con IGV: S/ \(moneda(resumen.totalConIGV))")
        print("Descuento 10% por cantidad: -S/ \(moneda(resumen.descuentoCantidad))")
        print("Descuento especial Tecsup: -S/ \(moneda(resumen.descuentoTecsup))")
        print("----------------------------------------")
        print("💰 TOTAL FINAL A PAGAR: S/ \(moneda(resumen.totalPagar))")
    }
}

func moneda(_ monto: Double) -> String {
    return String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), monto)
}

let alumno = Alumno(nombre: "Juan León", dni: "78965412", esTecsup: true)
let factura = FacturaCursos(alumno: alumno)
factura.agregar(curso: Curso(nombre: "Swift Avanzado", precio: 450), cantidad: 1)
factura.agregar(curso: Curso(nombre: "IA con Python", precio: 650), cantidad: 2)
factura.agregar(curso: Curso(nombre: "Diseño UX/UI", precio: 500), cantidad: 1)
factura.mostrarFactura()

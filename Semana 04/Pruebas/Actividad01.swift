// Se concatena después de Contents.swift para probar el mismo código del Playground.
func comprobarMonto(_ actual: Double, _ esperado: Double) {
    precondition(abs(actual - esperado) < 0.000001,
                 "Se esperaba \(esperado), se obtuvo \(actual)")
}

let ejemplo = factura.calcular()
precondition(ejemplo.cantidadCursos == 4)
comprobarMonto(ejemplo.subtotal, 2250)
comprobarMonto(ejemplo.igv, 405)
comprobarMonto(ejemplo.totalConIGV, 2655)
comprobarMonto(ejemplo.descuentoCantidad, 265.50)
comprobarMonto(ejemplo.descuentoTecsup, 400)
comprobarMonto(ejemplo.totalPagar, 1989.50)

// Fronteras 0, 1, 2, 3 y 4, tanto para alumnos Tecsup como externos.
for esTecsup in [false, true] {
    for cantidad in 0...4 {
        let prueba = FacturaCursos(alumno: Alumno(nombre: "Prueba", dni: "00000000", esTecsup: esTecsup))
        if cantidad > 0 {
            precondition(prueba.agregar(curso: Curso(nombre: "Curso de prueba", precio: 500), cantidad: cantidad))
        }
        let resultado = prueba.calcular()
        precondition(resultado.cantidadCursos == cantidad)
        let totalesExternos = [0.0, 590.0, 1180.0, 1593.0, 2124.0]
        let totalesTecsup = [0.0, 590.0, 1180.0, 1193.0, 1724.0]
        if esTecsup {
            comprobarMonto(resultado.totalPagar, totalesTecsup[cantidad])
        } else {
            comprobarMonto(resultado.totalPagar, totalesExternos[cantidad])
        }
        if cantidad < 3 {
            comprobarMonto(resultado.descuentoCantidad, 0)
            comprobarMonto(resultado.descuentoTecsup, 0)
        } else {
            comprobarMonto(resultado.descuentoCantidad, Double(cantidad) * 59)
            if esTecsup {
                comprobarMonto(resultado.descuentoTecsup, 400)
            } else {
                comprobarMonto(resultado.descuentoTecsup, 0)
            }
        }
    }
}

let invalida = FacturaCursos(alumno: alumno)
precondition(!invalida.agregar(curso: Curso(nombre: "Curso", precio: 100), cantidad: 0))
precondition(!invalida.agregar(curso: Curso(nombre: "Curso", precio: 100), cantidad: -1))
precondition(!invalida.agregar(curso: Curso(nombre: "Curso", precio: -100), cantidad: 1))
precondition(invalida.inscripciones.isEmpty)
print("PRUEBAS ACTIVIDAD 01: OK")

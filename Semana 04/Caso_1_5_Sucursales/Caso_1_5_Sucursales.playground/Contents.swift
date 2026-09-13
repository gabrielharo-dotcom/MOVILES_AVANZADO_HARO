// Desarrollado por: Gabriel Haro
// Laboratorio 04: Programacion Orientada a Objetos en Swift

import Foundation

// ===== CASO 1.5: HERENCIA Y POLIMORFISMO - LA CADENA DE SUCURSALES =====
// Docente: Juan Leon

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

// La clase base define el flujo comun de todas las cotizaciones.
class Sucursal {
    let nombre: String
    let ciudad: String

    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }

    func descuento() -> Double {
        return 0.05
    }

    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }

    // Este metodo se escribe una sola vez y no se sobreescribe en las subclases.
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

// TODO 14: SucursalLima
class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }

    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        }
        return 30.0
    }
}

// TODO 15: SucursalProvincia
class SucursalProvincia: Sucursal {
    // Hereda el descuento de 5 % definido en Sucursal.
    override func costoEnvio(monto: Double) -> Double {
        let envio = monto * 0.08
        if envio < 50.0 {
            return 50.0
        }
        return envio
    }
}

// TODO 16: SucursalOutlet
class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }

    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// TODO 18: prueba final del polimorfismo.
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}

// TODO 17: recorrido polimorfico obligatorio.
let refrigeradora = Electrodomestico(
    nombre: "Refrigeradora",
    marca: "Frost",
    precioLista: 2000.0,
    categoria: .lineaBlanca
)
let licuadora = Electrodomestico(
    nombre: "Licuadora",
    marca: "Mix",
    precioLista: 250.0,
    categoria: .pequenos
)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
    SucursalOnline(nombre: "Tienda Online", ciudad: "Internet")
]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// Para agregar SucursalOnline se necesitaron 6 lineas nuevas:
// 5 para declarar la clase y 1 para agregar su instancia al array.

// ===== FIX: Este codigo tenia 2 errores =====
class SucursalMall: Sucursal {
    override func descuento() -> Double { // FIX 7: falta override porque redefine un metodo heredado.
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int

    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        // FIX 8: se debe inicializar la clase base despues de radioKm.
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

// ===== PREDICT: Que imprime? =====
let misteriosa: Sucursal = SucursalLima(nombre: "Lima Centro", ciudad: "Lima")
print(misteriosa.descuento()) // PREDICT 6: 0.1; se usa el metodo de la instancia real SucursalLima.

let monto = 2000.0 * (1 - misteriosa.descuento())
print(misteriosa.costoEnvio(monto: monto)) // PREDICT 7: 0.0; el monto es 1800 y el envio es gratis.

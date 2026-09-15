import Foundation

// Actividad 02: herencia y polimorfismo de clientes.
class Cliente {
    let codigo: String
    let direccion: String
    let fechaDeRegistro: String
    let numeroCuenta: String
    let montoMinimoApertura: Double

    init(codigo: String, direccion: String, fechaDeRegistro: String,
         numeroCuenta: String, montoMinimoApertura: Double) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }

    func mostrarDatos() {
        print("📄 Código: \(codigo)")
        print("📍 Dirección: \(direccion)")
        print("📅 Fecha de registro: \(fechaDeRegistro)")
        print("🏦 Nº Cuenta: \(numeroCuenta)")
        let monto = String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), montoMinimoApertura)
        print("💰 Monto mínimo de apertura: S/ \(monto)")
    }
}

class ClienteNatural: Cliente {
    let nombreCompleto: String
    let dni: String

    init(nombreCompleto: String, dni: String, codigo: String,
         direccion: String, fechaDeRegistro: String,
         numeroCuenta: String, montoMinimoApertura: Double) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        // La clase base inicializa los datos que ambos tipos comparten.
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro,
                   numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }

    override func mostrarDatos() {
        print("👤 Cliente Natural:")
        print("Nombre: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

class ClienteJuridico: Cliente {
    let razonSocial: String
    let ruc: String
    let representanteLegal: String

    init(razonSocial: String, ruc: String, representanteLegal: String,
         codigo: String, direccion: String, fechaDeRegistro: String,
         numeroCuenta: String, montoMinimoApertura: Double) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro,
                   numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }

    override func mostrarDatos() {
        print("🏢 Cliente Jurídico:")
        print("Razón Social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante Legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}

let clienteNatural = ClienteNatural(
    nombreCompleto: "Juan Pérez", dni: "12345678", codigo: "C001",
    direccion: "Av. Lima 123", fechaDeRegistro: "2025-04-03",
    numeroCuenta: "001-2025-000123", montoMinimoApertura: 500)

let clienteJuridico = ClienteJuridico(
    razonSocial: "Soluciones SAC", ruc: "20123456789", representanteLegal: "María León",
    codigo: "C002", direccion: "Jr. Empresas 456", fechaDeRegistro: "2025-04-01",
    numeroCuenta: "001-2025-000456", montoMinimoApertura: 3000)

// Swift elige el override según la instancia real, aunque el array sea [Cliente].
let clientes: [Cliente] = [clienteNatural, clienteJuridico]
for cliente in clientes {
    cliente.mostrarDatos()
    print("----------------------------------------")
}

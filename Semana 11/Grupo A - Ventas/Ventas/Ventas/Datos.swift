//
//  Datos.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

enum Datos {

    static var contexto: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    static func guardar() -> Bool {
        do {
            try contexto.save()
            return true
        } catch {
            print("Error al guardar: \(error)")
            contexto.rollback()
            return false
        }
    }

    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    static func soles(_ valor: Double) -> String {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "en_US")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        return "S/ " + (formato.string(from: NSNumber(value: valor)) ?? "0.00")
    }

    static func iniciales(_ texto: String?) -> String {
        let partes = (texto ?? "").split(separator: " ").prefix(2)
        return partes.compactMap { $0.first }.map { String($0) }.joined().uppercased()
    }

    static func primerNombre(_ texto: String?) -> String {
        String((texto ?? "").split(separator: " ").first ?? "")
    }

    static func calcular(precio: Double, cantidad: Int, esVIP: Bool) -> (subtotal: Double, descuento: Double, igv: Double, total: Double) {
        let subtotal = redondear(precio * Double(cantidad))
        let descuento = esVIP ? redondear(subtotal * 0.10) : 0
        let igv = redondear((subtotal - descuento) * 0.18)
        let total = redondear(subtotal - descuento + igv)
        return (subtotal, descuento, igv, total)
    }

    static func totalComprado(_ cliente: Cliente) -> Double {
        let ventas = cliente.ventas as? Set<Venta> ?? []
        return redondear(ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total })
    }

    static func categoria(_ cliente: Cliente) -> String {
        let total = totalComprado(cliente)
        if total >= 5000 { return "VIP" }
        if total >= 1000 { return "Frecuente" }
        return "Regular"
    }

    static func inicioDelDia(_ fecha: Date) -> Date {
        Calendar.current.startOfDay(for: fecha)
    }

    static func inicioDelMes(_ fecha: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: fecha))!
    }

    static func sumarDias(_ dias: Int, a fecha: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: dias, to: fecha)!
    }

    static func predicadoPeriodo(_ indice: Int) -> NSPredicate? {
        switch indice {
        case 1: return NSPredicate(format: "fecha >= %@", inicioDelDia(Date()) as NSDate)
        case 2: return NSPredicate(format: "fecha >= %@", inicioDelMes(Date()) as NSDate)
        default: return nil
        }
    }

    static func ventas(_ condiciones: [NSPredicate]) -> [Venta] {
        let request: NSFetchRequest<Venta> = Venta.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        return (try? contexto.fetch(request)) ?? []
    }

    static func vendido(desde: Date, hasta: Date) -> [Venta] {
        ventas([NSPredicate(format: "anulada == NO AND fecha >= %@ AND fecha < %@", desde as NSDate, hasta as NSDate)])
    }

    static func total(_ ventas: [Venta]) -> Double {
        redondear(ventas.reduce(0) { $0 + $1.total })
    }

    static func fechaCorta(_ fecha: Date?) -> String {
        guard let fecha else { return "" }
        let formato = DateFormatter()
        formato.dateFormat = "dd/MM"
        return formato.string(from: fecha)
    }

    static func cargarDatosDeEjemplo() {
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        guard ((try? contexto.count(for: request)) ?? 0) == 0 else { return }

        _ = nuevoProducto("Laptop Pro 14", "Laptops", 200.00, 40)
        let monitor = nuevoProducto("Monitor 24\"", "Monitores", 450.00, 8)
        _ = nuevoProducto("Mouse inalámbrico", "Accesorios", 35.00, 120)
        let teclado = nuevoProducto("Teclado mecánico", "Accesorios", 129.90, 4)

        let andina = nuevoCliente("Comercial Andina SAC", "20000000001")
        let maria = nuevoCliente("María Quispe", "00000001")
        _ = nuevoCliente("Luis Rojas", "00000002")
        let sol = nuevoCliente("Tienda Sol EIRL", "20000000044")

        let carlos = nuevoUsuario("Carlos Ruiz", "cruiz", "123456", "Vendedor")
        let ana = nuevoUsuario("Ana Díaz", "adiaz", "123456", "Vendedor")

        let hoy = Date()
        nuevaVenta(carlos, andina, monitor, 10, sumarDias(-5, a: hoy))
        nuevaVenta(ana, maria, monitor, 2, sumarDias(-2, a: hoy))
        nuevaVenta(ana, sol, teclado, 1, sumarDias(-1, a: hoy))
        _ = guardar()
    }

    private static func nuevoProducto(_ nombre: String, _ categoria: String, _ precio: Double, _ stock: Int64) -> Producto {
        let producto = Producto(context: contexto)
        producto.nombre = nombre
        producto.categoria = categoria
        producto.precio = precio
        producto.stock = stock
        return producto
    }

    private static func nuevoCliente(_ nombre: String, _ documento: String) -> Cliente {
        let cliente = Cliente(context: contexto)
        cliente.nombre = nombre
        cliente.documento = documento
        return cliente
    }

    private static func nuevoUsuario(_ nombre: String, _ usuario: String, _ clave: String, _ rol: String) -> Usuario {
        let nuevo = Usuario(context: contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = rol
        return nuevo
    }

    private static func nuevaVenta(_ vendedor: Usuario, _ cliente: Cliente, _ producto: Producto, _ cantidad: Int, _ fecha: Date) {
        let calculo = calcular(precio: producto.precio, cantidad: cantidad, esVIP: false)
        let venta = Venta(context: contexto)
        venta.fecha = fecha
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = calculo.descuento
        venta.igv = calculo.igv
        venta.total = calculo.total
        venta.anulada = false
        venta.vendedor = vendedor
        venta.cliente = cliente
        venta.producto = producto
    }
}

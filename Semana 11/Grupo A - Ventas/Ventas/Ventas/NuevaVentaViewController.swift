//
//  NuevaVentaViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class NuevaVentaViewController: UIViewController {

    @IBOutlet weak var lblIniciales: UILabel!
    @IBOutlet weak var lblVendedor: UILabel!
    @IBOutlet weak var btnCliente: UIButton!
    @IBOutlet weak var btnProducto: UIButton!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblTituloDescuento: UILabel!
    @IBOutlet weak var lblDescuento: UILabel!
    @IBOutlet weak var lblIGV: UILabel!
    @IBOutlet weak var lblTotal: UILabel!

    var clientes = [Cliente]()
    var productos = [Producto]()
    var cliente: Cliente?
    var producto: Producto?

    override func viewDidLoad() {
        super.viewDidLoad()
        btnCliente.showsMenuAsPrimaryAction = true
        btnProducto.showsMenuAsPrimaryAction = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let usuario = Sesion.shared.usuario
        lblIniciales.text = Datos.iniciales(usuario?.nombre)
        lblVendedor.text = "\(usuario?.nombre ?? "") · \(usuario?.rol ?? "")"
        cargarListas()
        actualizar()
    }

    func cargarListas() {
        let pedirClientes: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        pedirClientes.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        clientes = (try? Datos.contexto.fetch(pedirClientes)) ?? []

        let pedirProductos: NSFetchRequest<Producto> = Producto.fetchRequest()
        pedirProductos.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        productos = (try? Datos.contexto.fetch(pedirProductos)) ?? []

        if let elegido = cliente, !clientes.contains(elegido) {
            cliente = nil
        }
        if let elegido = producto, !productos.contains(elegido) {
            producto = nil
        }

        btnCliente.menu = UIMenu(title: "Cliente", children: clientes.map { opcion in
            UIAction(title: opcion.nombre ?? "", subtitle: Datos.categoria(opcion),
                     state: opcion == cliente ? .on : .off) { [weak self] _ in
                self?.cliente = opcion
                self?.cargarListas()
                self?.actualizar()
            }
        })
        btnProducto.menu = UIMenu(title: "Producto", children: productos.map { opcion in
            UIAction(title: opcion.nombre ?? "", subtitle: "\(Datos.soles(opcion.precio)) · stock \(opcion.stock)",
                     state: opcion == producto ? .on : .off) { [weak self] _ in
                self?.producto = opcion
                self?.cargarListas()
                self?.actualizar()
            }
        })
    }

    func actualizar() {
        btnCliente.setTitle("\(cliente?.nombre ?? "Elegir") ›", for: .normal)
        btnProducto.setTitle("\(producto?.nombre ?? "Elegir") ›", for: .normal)

        let cantidad = Int(stepper.value)
        lblCantidad.text = "\(cantidad)"
        lblStock.text = producto.map { "(stock \($0.stock))" } ?? ""

        let esVIP = cliente.map { Datos.categoria($0) == "VIP" } ?? false
        let calculo = Datos.calcular(precio: producto?.precio ?? 0, cantidad: cantidad, esVIP: esVIP)
        lblSubtotal.text = Datos.soles(calculo.subtotal)
        lblTituloDescuento.text = esVIP ? "Descuento VIP 10%" : "Descuento"
        lblDescuento.text = "− \(Datos.soles(calculo.descuento))"
        lblIGV.text = Datos.soles(calculo.igv)
        lblTotal.text = Datos.soles(calculo.total)
    }

    @IBAction func cantidadCambio(_ sender: UIStepper) {
        actualizar()
    }

    @IBAction func registrarVenta(_ sender: UIButton) {
        guard let vendedor = Sesion.shared.usuario, let cliente = cliente, let producto = producto else {
            avisar("Faltan datos", "Elige el cliente y el producto.")
            return
        }
        let cantidad = Int(stepper.value)
        if Int64(cantidad) > producto.stock {
            avisar("Stock insuficiente", "Pediste \(cantidad) y solo hay \(producto.stock) unidades de \(producto.nombre ?? ""). La venta no se registró.")
            return
        }

        let calculo = Datos.calcular(precio: producto.precio, cantidad: cantidad, esVIP: Datos.categoria(cliente) == "VIP")
        let venta = Venta(context: Datos.contexto)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = calculo.descuento
        venta.igv = calculo.igv
        venta.total = calculo.total
        venta.anulada = false
        venta.vendedor = vendedor
        venta.cliente = cliente
        venta.producto = producto
        producto.stock -= Int64(cantidad)

        guard Datos.guardar() else {
            avisar("Error", "No se pudo registrar la venta.")
            return
        }
        avisar("Venta registrada", "Total \(Datos.soles(calculo.total)). Stock de \(producto.nombre ?? ""): \(producto.stock).")
        stepper.value = 1
        cargarListas()
        actualizar()
    }
}

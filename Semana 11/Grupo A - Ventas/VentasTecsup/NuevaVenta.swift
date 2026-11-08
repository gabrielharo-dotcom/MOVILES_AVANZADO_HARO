import UIKit

struct ImporteVenta {
    let subtotal: Decimal
    let descuento: Decimal
    let igv: Decimal
    let total: Decimal

    init(precio: Double, cantidad: Int64, categoria: CategoriaCliente) {
        subtotal = Self.redondear(decimalMoneda(precio) * Decimal(cantidad))
        descuento = categoria == .vip ? Self.redondear(subtotal / 10) : 0
        let base = subtotal - descuento
        igv = Self.redondear(base * 18 / 100)
        total = base + igv
    }

    private static func redondear(_ monto: Decimal) -> Decimal {
        var monto = monto
        var resultado = Decimal.zero
        NSDecimalRound(&resultado, &monto, 2, .plain)
        return resultado
    }
}

extension Almacen {
    func registrarVenta(cliente: Cliente, producto: Producto, cantidad: Int64) throws -> Venta {
        guard let vendedor = usuarioActual, vendedor.rol == Rol.vendedor.rawValue else {
            throw ErrorVentas("Solo un vendedor puede registrar una venta.")
        }
        guard cantidad > 0 else { throw ErrorVentas("La cantidad debe ser un entero mayor que cero.") }
        guard cantidad <= producto.stock else {
            throw ErrorVentas("Stock insuficiente. Quedan \(producto.stock) unidades.")
        }
        let categoria = CategoriaCliente(total: cliente.totalComprado)
        let importe = ImporteVenta(precio: producto.precio, cantidad: cantidad, categoria: categoria)
        let venta = Venta(context: contexto)
        venta.fecha = Date()
        venta.cantidad = cantidad
        venta.precioUnitario = producto.precio
        venta.descuento = NSDecimalNumber(decimal: importe.descuento).doubleValue
        venta.igv = NSDecimalNumber(decimal: importe.igv).doubleValue
        venta.total = NSDecimalNumber(decimal: importe.total).doubleValue
        venta.anulada = false
        venta.vendedor = vendedor
        venta.producto = producto
        venta.cliente = cliente
        producto.stock -= cantidad
        try guardar()
        return venta
    }
}

final class NuevaVentaViewController: Formulario {
    private let almacen: Almacen
    private let vendedor: Usuario
    private var cliente: Cliente?
    private var producto: Producto?
    private let clientes = UIButton(configuration: .tinted())
    private let productos = UIButton(configuration: .tinted())
    private let cantidad = campo("Cantidad")
    private let ajuste = UIStepper()
    private let stock = etiqueta("", estilo: .subheadline, color: .secondaryLabel)
    private let subtotal = etiqueta("—")
    private let descuento = etiqueta("—")
    private let igv = etiqueta("—")
    private let total = etiqueta("—", estilo: .headline)

    init(almacen: Almacen, vendedor: Usuario) {
        self.almacen = almacen
        self.vendedor = vendedor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva venta"
        clientes.showsMenuAsPrimaryAction = true
        productos.showsMenuAsPrimaryAction = true
        clientes.accessibilityLabel = "Cliente"
        productos.accessibilityLabel = "Producto"
        cantidad.text = "1"
        cantidad.keyboardType = .numberPad
        ajuste.minimumValue = 1
        ajuste.maximumValue = 999_999_999
        ajuste.value = 1
        ajuste.accessibilityLabel = "Ajustar cantidad"
        ajuste.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            cantidad.text = String(Int64(ajuste.value))
            calcular()
        }, for: .valueChanged)
        cantidad.addAction(UIAction { [weak self] _ in self?.calcular() }, for: .editingChanged)
        let unidades = UIStackView(arrangedSubviews: [cantidad, ajuste])
        unidades.spacing = 12
        cantidad.setContentHuggingPriority(.defaultLow, for: .horizontal)
        ajuste.setContentHuggingPriority(.required, for: .horizontal)

        let encabezado = etiqueta("\(vendedor.nombre) · \(vendedor.rol)", estilo: .headline, color: .systemBlue)
        for vista in [encabezado, clientes, productos, unidades, stock] as [UIView] {
            contenido.addArrangedSubview(vista)
        }
        contenido.addArrangedSubview(etiqueta("Resumen", estilo: .headline))
        contenido.addArrangedSubview(linea("Subtotal", subtotal))
        contenido.addArrangedSubview(linea("Descuento", descuento))
        contenido.addArrangedSubview(linea("IGV 18 %", igv))
        contenido.addArrangedSubview(linea("Total", total))
        contenido.addArrangedSubview(boton("Registrar venta") { [weak self] in self?.registrar() })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarOpciones()
    }

    private func linea(_ nombre: String, _ valor: UILabel) -> UIStackView {
        let fila = UIStackView(arrangedSubviews: [etiqueta(nombre), valor])
        fila.spacing = 10
        valor.textAlignment = .right
        valor.setContentHuggingPriority(.required, for: .horizontal)
        return fila
    }

    private func cargarOpciones() {
        do {
            let listaClientes = try almacen.clientes()
            let listaProductos = try almacen.productos()
            if let cliente, !listaClientes.contains(cliente) { self.cliente = nil }
            if let producto, !listaProductos.contains(producto) { self.producto = nil }
            clientes.menu = UIMenu(children: listaClientes.map { item in
                UIAction(title: item.nombre, subtitle: item.documento, state: item == cliente ? .on : .off) { [weak self] _ in
                    self?.cliente = item
                    self?.cargarOpciones()
                }
            })
            productos.menu = UIMenu(children: listaProductos.map { item in
                UIAction(title: item.nombre, subtitle: "\(soles(item.precio)) · \(item.stock) u.",
                         state: item == producto ? .on : .off) { [weak self] _ in
                    self?.producto = item
                    self?.cargarOpciones()
                }
            })
            clientes.isEnabled = !listaClientes.isEmpty
            productos.isEnabled = !listaProductos.isEmpty
            clientes.configuration?.title = cliente?.nombre ?? (listaClientes.isEmpty ? "Sin clientes" : "Elegir cliente")
            productos.configuration?.title = producto?.nombre ?? (listaProductos.isEmpty ? "Sin productos" : "Elegir producto")
            calcular()
        } catch { avisar("Nueva venta", error.localizedDescription) }
    }

    private func calcular() {
        stock.text = producto.map { "Stock disponible: \($0.stock) u." }
        guard let producto, let cliente, let unidades = Int64(cantidad.textoLimpio),
              (1...999_999_999).contains(unidades) else {
            for valor in [subtotal, descuento, igv, total] { valor.text = "—" }
            return
        }
        ajuste.value = Double(unidades)
        let categoria = CategoriaCliente(total: cliente.totalComprado)
        let importe = ImporteVenta(precio: producto.precio, cantidad: unidades, categoria: categoria)
        subtotal.text = soles(NSDecimalNumber(decimal: importe.subtotal).doubleValue)
        descuento.text = (categoria == .vip ? "VIP 10 % · −" : "") + soles(NSDecimalNumber(decimal: importe.descuento).doubleValue)
        igv.text = soles(NSDecimalNumber(decimal: importe.igv).doubleValue)
        total.text = soles(NSDecimalNumber(decimal: importe.total).doubleValue)
    }

    private func registrar() {
        view.endEditing(true)
        guard let cliente, let producto else {
            avisar("Completa la venta", "Selecciona un cliente y un producto.")
            return
        }
        guard let unidades = Int64(cantidad.textoLimpio), (1...999_999_999).contains(unidades) else {
            avisar("Revisa la cantidad", "Escribe un número entero positivo.")
            return
        }
        do {
            let venta = try almacen.registrarVenta(cliente: cliente, producto: producto, cantidad: unidades)
            self.producto = nil
            self.cliente = nil
            cantidad.text = "1"
            ajuste.value = 1
            cargarOpciones()
            avisar("Venta registrada", "Total \(soles(venta.total)). Stock restante: \(producto.stock) u.")
        } catch { avisar("No se pudo registrar", error.localizedDescription) }
    }
}

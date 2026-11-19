//
//  ResumenViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class ResumenViewController: UIViewController {

    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblSaludo: UILabel!
    @IBOutlet weak var lblRol: UILabel!
    @IBOutlet weak var lblVendidoHoy: UILabel!
    @IBOutlet weak var lblComparacion: UILabel!
    @IBOutlet weak var lblIGVMes: UILabel!
    @IBOutlet weak var stackBarras: UIStackView!
    @IBOutlet weak var stackDias: UIStackView!
    @IBOutlet weak var stackRanking: UIStackView!
    @IBOutlet weak var stackStockBajo: UIStackView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    func cargar() {
        let usuario = Sesion.shared.usuario
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_PE")
        formato.dateFormat = "EEEE d 'de' MMMM"
        let fecha = formato.string(from: Date())
        lblFecha.text = fecha.prefix(1).uppercased() + String(fecha.dropFirst())
        lblSaludo.text = "Hola, \(Datos.primerNombre(usuario?.nombre))"
        lblRol.text = "  \(usuario?.rol ?? "")  "

        let hoy = Datos.inicioDelDia(Date())
        let manana = Datos.sumarDias(1, a: hoy)
        let ayer = Datos.sumarDias(-1, a: hoy)

        let totalHoy = Datos.total(Datos.vendido(desde: hoy, hasta: manana))
        let totalAyer = Datos.total(Datos.vendido(desde: ayer, hasta: hoy))
        lblVendidoHoy.text = Datos.soles(totalHoy)
        if totalAyer > 0 {
            let variacion = (totalHoy - totalAyer) / totalAyer * 100
            lblComparacion.text = String(format: "%@ %.0f%% vs ayer", variacion >= 0 ? "▲" : "▼", abs(variacion))
            lblComparacion.textColor = variacion >= 0 ? .systemGreen : .systemRed
        } else {
            lblComparacion.text = "Sin ventas ayer"
            lblComparacion.textColor = .secondaryLabel
        }

        let delMes = Datos.vendido(desde: Datos.inicioDelMes(Date()), hasta: manana)
        lblIGVMes.text = Datos.soles(Datos.redondear(delMes.reduce(0) { $0 + $1.igv }))

        dibujarBarras(hoy: hoy)
        dibujarRanking(delMes)
        dibujarStockBajo()
    }

    func dibujarBarras(hoy: Date) {
        stackBarras.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackDias.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let letras = ["D", "L", "M", "X", "J", "V", "S"]
        let dias = (0..<7).map { Datos.sumarDias($0 - 6, a: hoy) }
        let montos = dias.map { Datos.total(Datos.vendido(desde: $0, hasta: Datos.sumarDias(1, a: $0))) }
        let mayor = montos.max() ?? 0

        for (indice, monto) in montos.enumerated() {
            let barra = UIView()
            barra.backgroundColor = indice == 6 ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
            barra.layer.cornerRadius = 4
            barra.translatesAutoresizingMaskIntoConstraints = false
            stackBarras.addArrangedSubview(barra)
            let proporcion = mayor > 0 ? max(monto / mayor, 0.03) : 0.03
            barra.heightAnchor.constraint(equalTo: stackBarras.heightAnchor, multiplier: CGFloat(proporcion)).isActive = true

            let dia = UILabel()
            dia.text = letras[Calendar.current.component(.weekday, from: dias[indice]) - 1]
            dia.font = .systemFont(ofSize: 11)
            dia.textColor = .secondaryLabel
            dia.textAlignment = .center
            stackDias.addArrangedSubview(dia)
        }
    }

    func dibujarRanking(_ ventasDelMes: [Venta]) {
        stackRanking.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var porVendedor = [String: Double]()
        for venta in ventasDelMes {
            porVendedor[venta.vendedor?.nombre ?? "Sin vendedor", default: 0] += venta.total
        }
        let ranking = porVendedor.sorted { $0.value > $1.value }
        guard let primero = ranking.first?.value, primero > 0 else {
            stackRanking.addArrangedSubview(etiqueta("Sin ventas este mes", color: .secondaryLabel))
            return
        }
        for (nombre, monto) in ranking {
            stackRanking.addArrangedSubview(etiqueta("\(nombre) · \(Datos.soles(Datos.redondear(monto)))", color: .label))
            let barra = UIProgressView(progressViewStyle: .bar)
            barra.progress = Float(monto / primero)
            stackRanking.addArrangedSubview(barra)
        }
    }

    func dibujarStockBajo() {
        stackStockBajo.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        request.predicate = NSPredicate(format: "stock <= 5")
        request.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        let productos = (try? Datos.contexto.fetch(request)) ?? []
        if productos.isEmpty {
            stackStockBajo.addArrangedSubview(etiqueta("Sin productos con stock bajo", color: .secondaryLabel))
        }
        for producto in productos {
            stackStockBajo.addArrangedSubview(etiqueta("\(producto.nombre ?? "") · \(producto.stock) u. · Reponer", color: .systemRed))
        }
    }

    func etiqueta(_ texto: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = color
        return label
    }
}

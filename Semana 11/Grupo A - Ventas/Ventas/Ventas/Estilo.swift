//
//  Estilo.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit

enum Estilo {

    static let paleta: [UIColor] = [.systemBlue, .systemPurple, .systemTeal, .systemPink, .systemOrange, .systemIndigo, .systemGreen]

    static func color(para texto: String?) -> UIColor {
        let suma = (texto ?? "").unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return paleta[suma % paleta.count]
    }

    static func colorStock(_ stock: Int64) -> UIColor {
        if stock > 10 { return .systemGreen }
        if stock >= 6 { return .systemOrange }
        return .systemRed
    }

    static func colorCategoria(_ categoria: String) -> UIColor {
        switch categoria {
        case "VIP": return .systemPurple
        case "Frecuente": return .systemBlue
        default: return .systemGray
        }
    }

    static func llenarChips(_ stack: UIStackView, titulos: [String], seleccionado: Int, accion: @escaping (Int) -> Void) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (indice, titulo) in titulos.enumerated() {
            var configuracion = indice == seleccionado ? UIButton.Configuration.filled() : UIButton.Configuration.gray()
            configuracion.title = titulo
            configuracion.cornerStyle = .capsule
            configuracion.buttonSize = .small
            let boton = UIButton(configuration: configuracion, primaryAction: UIAction { _ in accion(indice) })
            stack.addArrangedSubview(boton)
        }
    }
}

extension UIViewController {
    func avisar(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}

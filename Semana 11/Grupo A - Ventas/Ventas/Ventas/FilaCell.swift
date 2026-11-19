//
//  FilaCell.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit

class FilaCell: UITableViewCell {

    @IBOutlet weak var lblIniciales: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblSubtitulo: UILabel!
    @IBOutlet weak var lblMonto: UILabel!
    @IBOutlet weak var lblEtiqueta: UILabel!

    func configurar(iniciales: String, color: UIColor, titulo: String, subtitulo: String,
                    monto: String, etiqueta: String, colorEtiqueta: UIColor, tachado: Bool = false) {
        lblIniciales.text = iniciales
        lblIniciales.backgroundColor = color
        lblTitulo.text = titulo
        lblSubtitulo.text = subtitulo
        if tachado {
            lblMonto.attributedText = NSAttributedString(string: monto, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ])
        } else {
            lblMonto.attributedText = nil
            lblMonto.text = monto
            lblMonto.textColor = .label
        }
        lblEtiqueta.text = etiqueta.isEmpty ? "" : "  \(etiqueta)  "
        lblEtiqueta.backgroundColor = colorEtiqueta
        lblEtiqueta.isHidden = etiqueta.isEmpty
    }
}

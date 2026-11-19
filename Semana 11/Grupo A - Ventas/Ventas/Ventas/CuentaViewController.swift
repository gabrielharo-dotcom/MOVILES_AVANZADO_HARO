//
//  CuentaViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class CuentaViewController: UIViewController {

    @IBOutlet weak var lblIniciales: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblUsuario: UILabel!
    @IBOutlet weak var lblRol: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let usuario = Sesion.shared.usuario
        lblIniciales.text = Datos.iniciales(usuario?.nombre)
        lblNombre.text = usuario?.nombre
        lblUsuario.text = "Usuario: \(usuario?.usuario ?? "")"
        lblRol.text = "  \(usuario?.rol ?? "")  "
    }

    @IBAction func cerrarSesion(_ sender: UIButton) {
        Sesion.shared.usuario = nil
        let inicio = tabBarController?.presentingViewController as? UINavigationController
        tabBarController?.dismiss(animated: true) {
            inicio?.popToRootViewController(animated: false)
        }
    }
}

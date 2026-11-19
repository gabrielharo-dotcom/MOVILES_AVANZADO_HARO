//
//  LoginViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var lblError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Datos.cargarDatosDeEjemplo()
        lblError.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func ingresar(_ sender: UIButton) {
        let usuario = (txtUsuario.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = txtClave.text ?? ""

        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario, clave)
        guard let encontrado = (try? Datos.contexto.fetch(request))?.first else {
            lblError.text = "Usuario o clave incorrectos"
            lblError.isHidden = false
            return
        }

        lblError.isHidden = true
        txtClave.text = ""
        Sesion.shared.usuario = encontrado
        performSegue(withIdentifier: "entrar", sender: nil)
    }
}

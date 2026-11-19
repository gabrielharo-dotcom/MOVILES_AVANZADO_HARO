//
//  RegistroViewController.swift
//  Ventas
//
//  Created by oscarolano15@gmail.com on 12/11/26.
//

import UIKit
import CoreData

class RegistroViewController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var lblDisponible: UILabel!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtConfirmar: UITextField!
    @IBOutlet weak var segRol: UISegmentedControl!
    @IBOutlet weak var lblError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblDisponible.text = ""
        lblError.isHidden = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func existe(_ usuario: String) -> Bool {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        return ((try? Datos.contexto.count(for: request)) ?? 0) > 0
    }

    @IBAction func usuarioCambio(_ sender: UITextField) {
        let usuario = (sender.text ?? "").trimmingCharacters(in: .whitespaces)
        if usuario.isEmpty {
            lblDisponible.text = ""
        } else if existe(usuario) {
            lblDisponible.text = "✕ Ya existe"
            lblDisponible.textColor = .systemRed
        } else {
            lblDisponible.text = "✓ Disponible"
            lblDisponible.textColor = .systemGreen
        }
    }

    @IBAction func registrarme(_ sender: UIButton) {
        let nombre = (txtNombre.text ?? "").trimmingCharacters(in: .whitespaces)
        let usuario = (txtUsuario.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = txtClave.text ?? ""
        let confirmar = txtConfirmar.text ?? ""

        if nombre.isEmpty || usuario.isEmpty {
            mostrarError("Completa el nombre completo y el usuario.")
            return
        }
        if existe(usuario) {
            mostrarError("El usuario \(usuario) ya existe. Elige otro.")
            return
        }
        if clave.count < 6 {
            mostrarError("La clave debe tener mínimo 6 caracteres.")
            return
        }
        if clave != confirmar {
            mostrarError("La clave y su confirmación no coinciden.")
            return
        }

        let nuevo = Usuario(context: Datos.contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = segRol.selectedSegmentIndex == 0 ? "Vendedor" : "Supervisor"
        guard Datos.guardar() else {
            mostrarError("No se pudo crear el usuario.")
            return
        }

        lblError.isHidden = true
        Sesion.shared.usuario = nuevo
        performSegue(withIdentifier: "entrar", sender: nil)
    }

    func mostrarError(_ mensaje: String) {
        lblError.text = mensaje
        lblError.isHidden = false
    }
}

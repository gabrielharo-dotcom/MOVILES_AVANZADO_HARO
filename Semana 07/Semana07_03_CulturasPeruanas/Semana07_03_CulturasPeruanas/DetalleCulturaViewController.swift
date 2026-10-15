
import UIKit

class DetalleCulturaViewController: UIViewController {

    var cultura: Cultura?

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!

    @IBOutlet weak var btnTextileria: UIButton!
    @IBOutlet weak var btnCeramica: UIButton!
    @IBOutlet weak var btnArquitectura: UIButton!
    @IBOutlet weak var btnReligion: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let cultura = cultura else { return }

        title = cultura.nombre
        nombreLabel.text = "Cultura " + cultura.nombre
        regionLabel.text = "Región: " + cultura.region
        descripcionLabel.text = cultura.descripcion
        descripcionLabel.numberOfLines = 0

        imagenView.image = UIImage(named: cultura.imagen)
        imagenView.isAccessibilityElement = true
        imagenView.accessibilityLabel = "Imagen representativa de la cultura " + cultura.nombre

        configurarBotonesTematicos()
    }

    
    @IBAction func seleccionarTema(_ sender: UIButton) {

        guard let cultura = cultura else { return }

        let temas = [
            "Textilería",
            "Cerámica",
            "Arquitectura",
            "Religión"
        ]

        guard sender.tag >= 0 && sender.tag < temas.count else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let pantalla = storyboard.instantiateViewController(
            withIdentifier: "ExplicacionViewController"
        ) as? ExplicacionViewController else {
            return
        }

        pantalla.nombreCultura = cultura.nombre
        pantalla.temaSeleccionado = temas[sender.tag]

        navigationController?.pushViewController(
            pantalla,
            animated: true
        )
    }


    func configurarBotonesTematicos() {

        guard let cultura = cultura else { return }

        let nombre = cultura.nombre.folding(
            options: .diacriticInsensitive,
            locale: .current
        ).capitalized

        configurarBoton(btnTextileria, titulo: "Textilería", imagen: "\(nombre)_Textileria")

        configurarBoton(btnCeramica, titulo: "Cerámica", imagen: "\(nombre)_Ceramica")

        configurarBoton(btnArquitectura, titulo: "Arquitectura", imagen: "\(nombre)_Arquitectura")

        configurarBoton(btnReligion, titulo: "Religión", imagen: "\(nombre)_Religion")
    }

    func configurarBoton(_ boton: UIButton, titulo: String, imagen: String) {

        var configuracion = UIButton.Configuration.filled()

        configuracion.title = titulo

        if let imagenOriginal = UIImage(named: imagen) {

            let tamaño = CGSize(width: 48, height: 48)

            let renderizador = UIGraphicsImageRenderer(size: tamaño)

            let miniatura = renderizador.image { _ in

                let escala = max(
                    tamaño.width / imagenOriginal.size.width,
                    tamaño.height / imagenOriginal.size.height
                )

                let ancho = imagenOriginal.size.width * escala
                let alto = imagenOriginal.size.height * escala

                let rectangulo = CGRect(
                    x: (tamaño.width - ancho) / 2,
                    y: (tamaño.height - alto) / 2,
                    width: ancho,
                    height: alto
                )

                imagenOriginal.draw(in: rectangulo)
            }

            configuracion.image = miniatura.withRenderingMode(.alwaysOriginal)
        }

        configuracion.imagePlacement = .leading
        configuracion.imagePadding = 12
        configuracion.cornerStyle = .medium

        configuracion.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 10,
            bottom: 8,
            trailing: 10
        )

        boton.configuration = configuracion
        boton.contentHorizontalAlignment = .leading
    }
}

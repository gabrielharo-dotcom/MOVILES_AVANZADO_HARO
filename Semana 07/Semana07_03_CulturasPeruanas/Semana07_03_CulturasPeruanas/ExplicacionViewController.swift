
import UIKit

class ExplicacionViewController: UIViewController {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var descripcionLabel: UILabel!

    var nombreCultura = ""
    var temaSeleccionado = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = temaSeleccionado

        tituloLabel.text = "\(temaSeleccionado) de \(nombreCultura)"
        tituloLabel.numberOfLines = 0

        descripcionLabel.text = obtenerExplicacion()
        descripcionLabel.numberOfLines = 0

        let nombreImagen = nombreCultura
            .folding(options: .diacriticInsensitive, locale: .current)
            .capitalized

        let temaImagen = temaSeleccionado
            .folding(options: .diacriticInsensitive, locale: .current)

        imagenView.image = UIImage(
            named: "\(nombreImagen)_\(temaImagen)"
        )

        imagenView.contentMode = .scaleAspectFit
    }

    func obtenerExplicacion() -> String {

        let explicaciones: [String: [String: String]] = [
            "Inca": [
                "Textilería": "Los incas desarrollaron una importante producción textil utilizando algodón y fibras de alpaca y vicuña. Elaboraron prendas destinadas al uso cotidiano y tejidos finos llamados cumbi, utilizados por la élite y en ceremonias. Sus diseños incluían figuras geométricas que podían representar elementos sociales y culturales.",
                "Cerámica": "La cerámica inca destacó por su utilidad y sus diseños geométricos. Uno de sus recipientes más representativos fue el aríbalo, empleado principalmente para almacenar y transportar líquidos. También fabricaron platos y otros objetos de uso doméstico y ceremonial.",
                "Arquitectura": "Los incas construyeron templos, fortalezas, centros administrativos y caminos. Destacaron por el trabajo preciso de la piedra, que permitió levantar estructuras resistentes. Machu Picchu, Sacsayhuamán y Ollantaytambo son ejemplos importantes de su arquitectura.",
                "Religión": "La religión inca fue politeísta y estuvo relacionada con la naturaleza. Entre sus principales divinidades se encontraban Inti, dios del Sol, y Viracocha. También otorgaban importancia a la Pachamama y a los lugares sagrados conocidos como huacas."
            ],

            "Nazca": [
                "Textilería": "Los nazcas elaboraron textiles con algodón y fibras de camélidos. Utilizaron colores variados, bordados y representaciones de animales, plantas y seres sobrenaturales. Sus tejidos formaban parte de la vestimenta y de diversas actividades ceremoniales.",
                "Cerámica": "La cultura Nazca destacó por su cerámica policroma, decorada con numerosos colores. Representaban animales, plantas, personajes y seres mitológicos. Sus recipientes incluían cuencos, botellas y vasijas de doble pico con asa puente.",
                "Arquitectura": "La arquitectura Nazca utilizó principalmente adobe y otros materiales disponibles en la costa sur. Su centro ceremonial más conocido fue Cahuachi, formado por pirámides y plazas. También desarrollaron sistemas hidráulicos para aprovechar el agua en un ambiente desértico.",
                "Religión": "Las creencias nazcas estuvieron relacionadas con la fertilidad, el agua y los seres sobrenaturales. Sus ceremonias incluían ofrendas y actividades rituales. Las Líneas de Nazca han sido interpretadas como parte de prácticas ceremoniales, aunque su función exacta continúa siendo investigada."
            ],

            "Chavín": [
                "Textilería": "La cultura Chavín elaboró textiles decorados con símbolos religiosos y figuras de animales. Entre sus representaciones destacaron los felinos, las serpientes y las aves. Estas imágenes estuvieron vinculadas con la iconografía religiosa que caracterizó a esta sociedad.",
                "Cerámica": "La cerámica Chavín se caracterizó por sus colores oscuros, superficies pulidas y decoraciones relacionadas con animales y seres sobrenaturales. Fabricaron botellas con asa estribo y recipientes utilizados en diferentes actividades.",
                "Arquitectura": "La principal expresión arquitectónica fue el centro ceremonial de Chavín de Huántar, ubicado en Áncash. Sus construcciones incluyeron templos, plazas, galerías subterráneas y sistemas de drenaje. Destacan esculturas como el Lanzón Monolítico y las cabezas clavas.",
                "Religión": "La religión tuvo un papel central en la cultura Chavín. Sus divinidades fueron representadas mediante rasgos de felinos, serpientes y aves rapaces. Chavín de Huántar fue un importante lugar de reunión y celebración de ceremonias religiosas."
            ],

            "Paracas": [
                "Textilería": "La cultura Paracas destacó por sus mantos funerarios elaborados con gran precisión. Utilizaron algodón y fibras de camélidos, combinando numerosos colores y complejos bordados. Sus representaciones incluían personajes, animales y seres sobrenaturales.",
                "Cerámica": "La cerámica Paracas presentó diversos estilos durante su desarrollo. Algunas piezas fueron decoradas con figuras geométricas y representaciones de animales. En determinados periodos se utilizaron pinturas aplicadas después de la cocción.",
                "Arquitectura": "Los paracas construyeron asentamientos y espacios ceremoniales utilizando materiales como adobe y piedra. Entre los lugares arqueológicos asociados a esta sociedad destaca el complejo de Ánimas Altas, en el valle de Ica.",
                "Religión": "Las prácticas religiosas de Paracas estuvieron estrechamente relacionadas con el tratamiento de los muertos. Los cuerpos eran preparados y colocados en fardos funerarios acompañados de textiles y otros objetos. Estas costumbres reflejan la importancia de sus creencias sobre la muerte y los antepasados."
            ]
        ]

        let claveCultura = nombreCultura
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()

        let nombres = [
            "inca": "Inca",
            "nazca": "Nazca",
            "chavin": "Chavín",
            "paracas": "Paracas"
        ]

        guard let cultura = nombres[claveCultura] else {
            return "No se encontró información de esta cultura."
        }

        return explicaciones[cultura]?[temaSeleccionado]
            ?? "No hay información disponible para este tema."
    }
}


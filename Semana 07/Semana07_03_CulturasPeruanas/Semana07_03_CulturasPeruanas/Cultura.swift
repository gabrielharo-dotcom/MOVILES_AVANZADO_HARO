import UIKit

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String

    static let ejemplos = [
        Cultura(
            nombre: "Inca",
            region: "Cusco, sierra sur del Perú",
            descripcion: "La cultura inca dejó un importante legado arquitectónico en los Andes. Machu Picchu es uno de sus sitios más representativos: sus muros de piedra, terrazas y construcciones se integran al paisaje montañoso.",
            imagen: "inca"
        ),
        Cultura(
            nombre: "Nazca",
            region: "Ica, costa sur del Perú",
            descripcion: "La cultura Nazca es conocida por los geoglifos trazados en el desierto. Entre sus figuras se encuentran animales, plantas y formas geométricas. El colibrí es una de las imágenes más reconocidas de este patrimonio.",
            imagen: "nazca"
        ),
        Cultura(
            nombre: "Chavín",
            region: "Áncash, sierra norte del Perú",
            descripcion: "Chavín de Huántar fue un importante centro ceremonial de los Andes. Su arquitectura y sus esculturas de piedra reflejan una tradición religiosa de gran influencia. Las cabezas clavas son una de sus expresiones más representativas.",
            imagen: "chavin"
        ),
        Cultura(
            nombre: "Paracas",
            region: "Ica, costa sur del Perú",
            descripcion: "La cultura Paracas destacó por la calidad de sus textiles, elaborados con algodón y fibras de camélidos. Sus tejidos presentan figuras y colores que expresan su tradición artística. La península de Paracas, en Ica, conserva importantes testimonios de esta cultura.",
            imagen: "paracas"
        )
    ]
}

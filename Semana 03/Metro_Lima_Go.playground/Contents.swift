import Foundation

enum Linea: String {
    case l1 = "Línea 1"
    case l2 = "Línea 2"
    case l4 = "Ramal Línea 4"
    case met = "Metropolitano"
}

enum Estado: String {
    case operativa = "Operativa"
    case construccion = "En construcción"
    case proyectada = "Proyectada"
}

enum TipoConexion: String {
    case intercambio = "Intercambio"
    case metropolitano = "Conexión con Metropolitano"
}

struct Conexion {
    let tipo: TipoConexion
    let destino: String
    let estado: Estado
    let detalle: String
}

struct Estacion {
    let codigo: String
    let nombre: String
    let linea: Linea
    let estado: Estado
    let ascensor: Bool?
    let accesible: Bool
    let anio: Int?
    var conexiones: [Conexion] = []
    var nota: String = ""
}

struct Destino {
    let nombre: String
    let estacion: String
    let detalle: String
}

struct TarjetaTransporte {

    let numero: String

    var saldo: Double

    var viajesRealizados: Int = 0

    mutating func recargar(
        _ monto: Double
    ) -> Bool {

        guard monto > 0 else {

            return false
        }

        saldo += monto

        return true
    }

    mutating func cobrar(
        _ monto: Double
    ) -> Bool {

        guard
            monto > 0,
            saldo >= monto
        else {

            return false
        }

        saldo -= monto

        viajesRealizados += 1

        return true
    }
}

var tarjetaUsuario =
    TarjetaTransporte(
        numero: "TIT-0001",
        saldo: 10.00
    )

func norm(_ s: String) -> String {
    s.folding(
        options: [.diacriticInsensitive, .caseInsensitive],
        locale: Locale(identifier: "es_PE")
    )
    .lowercased()
    .trimmingCharacters(in: .whitespacesAndNewlines)
}

func l2(_ s: String) -> String {
    "\(s) (L2)"
}

func l4(_ s: String) -> String {
    "\(s) (L4)"
}

func met(_ s: String) -> String {
    "\(s) (Metropolitano)"
}

func siNo(_ b: Bool) -> String {
    b ? "Sí" : "No"
}

func datoAscensor(_ b: Bool?) -> String {
    b.map { $0 ? "Sí" : "No" } ?? "No verificado"
}

let totalLineasMetro = 6

let referenciaMetL1: [String: (paradero: String, detalle: String)] = [
    "Cabitos": (
        "Benavides",
        "Referencia aproximada por el eje Benavides/Higuereta; requiere transporte complementario."
    ),
    "Angamos": (
        "Angamos",
        "Referencia aproximada por la avenida Angamos; requiere transporte complementario."
    ),
    "La Cultura": (
        "Javier Prado",
        "Referencia aproximada por el corredor Javier Prado; requiere transporte complementario."
    ),
    "Grau": (
        "Central",
        "Integración prevista mediante la Vía Expresa Grau; todavía no es un intercambio directo operativo."
    )
]

let enlacesSuperficieL1Met = [
    ("Cabitos", met("Benavides")),
    ("Angamos", met("Angamos")),
    ("La Cultura", met("Javier Prado"))
]

let recomendacionClave: [String: String] = [
    l2("28 de Julio"):
        "Referencia temporal: Gamarra (Línea 1) mediante traslado peatonal propuesto; el intercambio definitivo L1-L2 será en 28 de Julio.",

    l2("Estación Central"):
        "Al culminar las obras, conecta directamente con Central del Metropolitano mediante una galería subterránea de ~180 m.",

    "Grau":
        "No es cruce directo. Como alternativa futura se puede usar Central y luego transporte complementario hacia Grau."
]

var estaciones: [String: Estacion] = [:]

func guardar(_ clave: String, _ estacion: Estacion) {
    estaciones[clave] = estacion
}

func conectar(_ clave: String, _ conexion: Conexion) {
    guard var estacion = estaciones[clave] else {
        return
    }

    estacion.conexiones.append(conexion)
    estaciones[clave] = estacion
}

let nombresL1 = [
    "Villa El Salvador",
    "Parque Industrial",
    "Pumacahua",
    "Villa María",
    "María Auxiliadora",
    "San Juan",
    "Atocongo",
    "Jorge Chávez",
    "Ayacucho",
    "Cabitos",
    "Angamos",
    "San Borja Sur",
    "La Cultura",
    "Arriola",
    "Gamarra",
    "Grau",
    "El Ángel",
    "Presbítero Maestro",
    "Caja de Agua",
    "Pirámide del Sol",
    "Los Jardines",
    "Los Postes",
    "San Carlos",
    "San Martín",
    "Santa Rosa",
    "Bayóvar"
]

let sinAscensor: Set<String> = [
    "Pumacahua",
    "Villa María",
    "María Auxiliadora",
    "San Borja Sur"
]

for (i, nombre) in nombresL1.enumerated() {

    var nota = "Estación operativa de Línea 1."

    if sinAscensor.contains(nombre) {
        nota += " Usa salvaescaleras para accesibilidad."
    }

    if nombre == "Grau" {
        nota += " Grau NO conecta directamente con Línea 2."
    }

    guardar(
        nombre,
        Estacion(
            codigo: "L1-\(String(format: "%02d", i + 1))",
            nombre: nombre,
            linea: .l1,
            estado: .operativa,
            ascensor: !sinAscensor.contains(nombre),
            accesible: true,
            anio: nil,
            nota: nota
        )
    )
}

guardar(
    "28 de Julio (L1 futura)",
    Estacion(
        codigo: "L1-FUT-28J",
        nombre: "28 de Julio",
        linea: .l1,
        estado: .proyectada,
        ascensor: true,
        accesible: true,
        anio: nil,
        nota: "Futura estación de intercambio con Línea 2. No está operativa."
    )
)

let nombresL2 = [
    "Puerto del Callao",
    "Buenos Aires",
    "Juan Pablo II",
    "Insurgentes",
    "Carmen de la Legua",
    "Óscar R. Benavides",
    "San Marcos",
    "Elio",
    "La Alborada",
    "Tingo María",
    "Parque Murillo",
    "Plaza Bolognesi",
    "Estación Central",
    "Manco Cápac",
    "Cangallo",
    "28 de Julio",
    "Nicolás Ayllón",
    "Circunvalación",
    "San Juan de Dios",
    "Evitamiento",
    "Óvalo Santa Anita",
    "Colectora Industrial",
    "Hermilio Valdizán",
    "Mercado Santa Anita",
    "Vista Alegre",
    "Prolongación Javier Prado",
    "Municipalidad de Ate"
]

for (i, nombre) in nombresL2.enumerated() {

    let numero = i + 1

    let operativa = (20...24).contains(numero)

    let etapa1B =
        (12...19).contains(numero) ||
        (25...27).contains(numero)

    var nota = ""

    if operativa {

        nota =
            "Etapa 1A habilitada. Usa Tarjeta Interoperable de Transporte."

    } else if etapa1B {

        nota =
            "Estación de Línea 2 en construcción."

    } else {

        nota =
            "Estación correspondiente a una futura etapa de Línea 2."
    }

    if nombre == "28 de Julio" {
        nota += " Será intercambio con Línea 1."
    }

    if nombre == "Estación Central" {
        nota += " Tendrá conexión con el Metropolitano."
    }

    if nombre == "Carmen de la Legua" {
        nota += " Tendrá intercambio con el Ramal Línea 4."
    }

    guardar(
        l2(nombre),
        Estacion(
            codigo: "L2-E\(String(format: "%02d", numero))",
            nombre: nombre,
            linea: .l2,
            estado: operativa ? .operativa : .construccion,
            ascensor: true,
            accesible: true,
            anio: operativa ? nil : 2030,
            nota: nota
        )
    )
}

let nombresL4 = [
    "Gambetta",
    "Canta Callao",
    "Bocanegra",
    "Aeropuerto",
    "El Olivar",
    "Quilca",
    "Morales Duárez",
    "Carmen de la Legua"
]

for (i, nombre) in nombresL4.enumerated() {

    guardar(
        l4(nombre),
        Estacion(
            codigo: "L4-R\(String(format: "%02d", i + 1))",
            nombre: nombre,
            linea: .l4,
            estado: .construccion,
            ascensor: true,
            accesible: true,
            anio: 2030,
            nota: "Ramal Línea 4 en construcción."
        )
    )
}

let nombresMet = [
    "Jirón de la Unión",
    "Central",
    "Estadio Nacional",
    "México",
    "Canadá",
    "Javier Prado",
    "Canaval y Moreyra",
    "Aramburú",
    "Angamos",
    "Ricardo Palma",
    "Benavides",
    "28 de Julio"
]

for (i, nombre) in nombresMet.enumerated() {

    var nota =
        "Estación operativa del Metropolitano incluida en el prototipo."

    if nombre == "Central" {
        nota += " Útil para acceder al Centro Cívico."
    }

    if nombre == "Estadio Nacional" {
        nota += " Permite acceder al Estadio Nacional."
    }

    if nombre == "Canaval y Moreyra" {
        nota += " Útil para San Isidro."
    }

    if nombre == "Ricardo Palma" {
        nota += " Útil para Miraflores y Parque Kennedy."
    }

    guardar(
        met(nombre),
        Estacion(
            codigo: "MET-\(String(format: "%02d", i + 1))",
            nombre: nombre,
            linea: .met,
            estado: .operativa,
            ascensor: nil,
            accesible: true,
            anio: nil,
            nota: nota
        )
    )
}

conectar(
    l2("28 de Julio"),
    Conexion(
        tipo: .intercambio,
        destino: "28 de Julio (L1 futura)",
        estado: .construccion,
        detalle: "Futuro intercambio entre Línea 1 y Línea 2."
    )
)

conectar(
    l2("Estación Central"),
    Conexion(
        tipo: .metropolitano,
        destino: met("Central"),
        estado: .construccion,
        detalle: "Conexión futura con el Metropolitano."
    )
)

conectar(
    l2("Carmen de la Legua"),
    Conexion(
        tipo: .intercambio,
        destino: l4("Carmen de la Legua"),
        estado: .construccion,
        detalle: "Futuro intercambio entre Línea 2 y Ramal Línea 4."
    )
)

let destinos: [String: Destino] = [

    "estadio nacional":
        Destino(
            nombre: "Estadio Nacional del Perú",
            estacion: met("Estadio Nacional"),
            detalle:
                "Usa el Metropolitano y baja en Estadio Nacional."
        ),

    "miraflores":
        Destino(
            nombre: "Miraflores",
            estacion: met("Ricardo Palma"),
            detalle:
                "Ricardo Palma es una opción práctica para llegar al centro de Miraflores."
        ),

    "parque kennedy":
        Destino(
            nombre: "Parque Kennedy",
            estacion: met("Ricardo Palma"),
            detalle:
                "Baja en Ricardo Palma y continúa a pie."
        ),

    "centro de lima":
        Destino(
            nombre: "Centro Histórico de Lima",
            estacion: met("Jirón de la Unión"),
            detalle:
                "Jirón de la Unión permite acceder al Centro Histórico."
        ),

    "centro historico":
        Destino(
            nombre: "Centro Histórico de Lima",
            estacion: met("Jirón de la Unión"),
            detalle:
                "Jirón de la Unión permite acceder al Centro Histórico."
        ),

    "centro civico":
        Destino(
            nombre: "Centro Cívico",
            estacion: met("Central"),
            detalle:
                "La Estación Central es una opción para el Centro Cívico."
        ),

    "san isidro":
        Destino(
            nombre: "Centro financiero de San Isidro",
            estacion: met("Canaval y Moreyra"),
            detalle:
                "Canaval y Moreyra es una opción para San Isidro."
        ),

    "gamarra":
        Destino(
            nombre: "Emporio Comercial de Gamarra",
            estacion: "Gamarra",
            detalle:
                "Usa Línea 1 y baja en Gamarra."
        ),

    "museo de la nacion":
        Destino(
            nombre: "Museo de la Nación",
            estacion: "La Cultura",
            detalle:
                "Usa Línea 1 y baja en La Cultura."
        ),

    "aeropuerto":
        Destino(
            nombre: "Aeropuerto Internacional Jorge Chávez",
            estacion: l4("Aeropuerto"),
            detalle:
                "La futura estación Aeropuerto del Ramal Línea 4 todavía está en construcción."
        )
]

let serviciosPorLinea: [Linea: [String]] = [

    .l1: [
        "Boletería y recarga",
        "Torniquetes",
        "Personal de orientación",
        "Servicios de accesibilidad",
        "Señalización de salida"
    ],

    .l2: [
        "Máquinas de recarga",
        "Torniquetes",
        "Ascensores",
        "Señalización de andenes",
        "Personal de orientación"
    ],

    .l4: [
        "Infraestructura proyectada",
        "Accesibilidad planificada",
        "Señalización futura"
    ],

    .met: [
        "Zona de embarque",
        "Recarga de tarjeta",
        "Personal de orientación",
        "Señalización de rutas",
        "Accesos peatonales"
    ]
]

let puntosCercanos: [String: [String]] = [

    "Gamarra": [
        "Emporio Comercial de Gamarra",
        "Comercios",
        "Transporte urbano"
    ],

    "La Cultura": [
        "Museo de la Nación",
        "Gran Teatro Nacional",
        "Zona cultural"
    ],

    met("Estadio Nacional"): [
        "Estadio Nacional",
        "Parque de la Reserva",
        "Zona deportiva"
    ],

    met("Ricardo Palma"): [
        "Parque Kennedy",
        "Centro de Miraflores",
        "Comercios y restaurantes"
    ],

    met("Central"): [
        "Centro Cívico",
        "Centro Histórico cercano",
        "Centros comerciales"
    ],

    met("Canaval y Moreyra"): [
        "Centro financiero de San Isidro",
        "Oficinas",
        "Comercios"
    ],

    l4("Aeropuerto"): [
        "Aeropuerto Internacional Jorge Chávez",
        "Terminal aérea",
        "Servicios aeroportuarios"
    ]
]

func experienciaAlLlegar(_ clave: String) {

    guard let estacion = estaciones[clave] else {
        return
    }

    print("\n===== AL LLEGAR A \(estacion.nombre) =====")

    print("La persona encontrará:")

    let servicios =
        serviciosPorLinea[
            estacion.linea,
            default: ["Señalización", "Zona de acceso"]
        ]

    for servicio in servicios {
        print("- \(servicio)")
    }

    if let lugares = puntosCercanos[clave] {

        print("\nLugares cercanos:")

        for lugar in lugares {
            print("- \(lugar)")
        }

    } else {

        print("- Salidas hacia calles y transporte urbano.")
    }

    if !estacion.conexiones.isEmpty {

        print("\nConexiones:")

        for conexion in estacion.conexiones {

            print(
                "- \(conexion.destino) - \(conexion.estado.rawValue)"
            )
        }
    }
}

func buscar(_ texto: String) -> [(String, Estacion)] {

    let consulta = norm(texto)

    return estaciones
        .filter {

            norm($0.key).contains(consulta) ||
            norm($0.value.nombre).contains(consulta) ||
            norm($0.value.codigo).contains(consulta)
        }
        .sorted {

            $0.value.nombre < $1.value.nombre
        }
}

func resolver(_ texto: String) -> String? {

    let consulta = norm(texto)

    if let clave = estaciones.keys.first(
        where: { norm($0) == consulta }
    ) {

        return clave
    }

    let exactas = estaciones.filter {
        norm($0.value.nombre) == consulta
    }

    if exactas.count == 1 {
        return exactas.first?.key
    }

    let resultados = buscar(texto)

    if resultados.count == 1 {
        return resultados[0].0
    }

    return nil
}

func elegir(_ resultados: [(String, Estacion)]) -> String? {

    if resultados.count == 1 {
        return resultados[0].0
    }

    for (i, resultado) in resultados.enumerated() {

        print(
            "\(i + 1). \(resultado.1.nombre) - \(resultado.1.linea.rawValue)"
        )
    }

    guard
        let texto = readLine(),
        let numero = Int(texto),
        (1...resultados.count).contains(numero)
    else {

        return nil
    }

    return resultados[numero - 1].0
}

func mostrar(_ clave: String) {

    guard let estacion = estaciones[clave] else {
        return
    }

    print("\n===== \(estacion.nombre) =====")

    print("Código: \(estacion.codigo)")
    print("Línea: \(estacion.linea.rawValue)")
    print("Estado: \(estacion.estado.rawValue)")
    print("Accesible: \(siNo(estacion.accesible))")
    print("Ascensor: \(datoAscensor(estacion.ascensor))")

    if let anio = estacion.anio {

        print("Año previsto: \(anio)")
    }

    print("Información: \(estacion.nota)")

    if let recomendacion = recomendacionClave[clave] {

        print("Recomendación: \(recomendacion)")
    }

    if estacion.linea == .l1,
       let referencia = referenciaMetL1[estacion.nombre] {

        print(
            "Metropolitano de referencia: \(referencia.paradero)"
        )

        print(referencia.detalle)
    }

    if estacion.conexiones.isEmpty {

        print("Conexiones especiales: ninguna.")

    } else {

        print("Conexiones:")

        for conexion in estacion.conexiones {

            print(
                "- \(conexion.destino) [\(conexion.estado.rawValue)]"
            )

            print("  \(conexion.detalle)")
        }
    }
}

func opcionBuscar() {

    print("Ingrese una estación:")

    guard
        let texto = readLine(),
        !norm(texto).isEmpty
    else {

        print("Entrada inválida.")
        return
    }

    let resultados = buscar(texto)

    if resultados.isEmpty {

        print("No se encontraron resultados.")
        return
    }

    if let clave = elegir(resultados) {

        mostrar(clave)
    }
}

func listar(_ linea: Linea) {

    let lista = estaciones.values
        .filter { $0.linea == linea }
        .sorted { $0.codigo < $1.codigo }

    print("\n===== \(linea.rawValue) =====")

    for estacion in lista {

        print(
            "\(estacion.codigo) | \(estacion.nombre) | \(estacion.estado.rawValue)"
        )
    }
}

func opcionLinea() {

    print("""
    1. Línea 1
    2. Línea 2
    3. Ramal Línea 4
    4. Metropolitano
    """)

    switch readLine() {

    case "1":
        listar(.l1)

    case "2":
        listar(.l2)

    case "3":
        listar(.l4)

    case "4":
        listar(.met)

    default:
        print("Opción inválida.")
    }
}

func cruces() {

    print("""
    
    ===== CRUCES IMPORTANTES =====

    28 de Julio
    Línea 1 <-> Línea 2
    Estado: En construcción

    Estación Central
    Línea 2 <-> Metropolitano
    Estado: En construcción

    Carmen de la Legua
    Línea 2 <-> Ramal Línea 4
    Estado: En construcción

    Grau
    No es un intercambio directo con Línea 2.
    """)
}

func buscarDestino(_ texto: String) -> Destino? {

    let consulta = norm(texto)

    if let destino = destinos[consulta] {

        return destino
    }

    return destinos.first {

        consulta.contains($0.key) ||
        $0.key.contains(consulta)

    }?.value
}

func opcionDestino() {

    print(
        "Destino: Estadio Nacional / Miraflores / Centro de Lima / San Isidro / Gamarra / Aeropuerto"
    )

    guard
        let texto = readLine(),
        let destino = buscarDestino(texto)
    else {

        print("Destino no registrado.")
        return
    }

    print("\nDestino: \(destino.nombre)")
    print("Estación recomendada: \(destino.estacion)")
    print(destino.detalle)

    if let estacion = estaciones[destino.estacion] {

        print("Estado: \(estacion.estado.rawValue)")

        if estacion.estado != .operativa {

            print(
                "ADVERTENCIA: esta infraestructura todavía no está operativa."
            )
        }
    }
}

typealias Grafo = [String: [String]]

func unir(
    _ a: String,
    _ b: String,
    _ grafo: inout Grafo
) {

    grafo[a, default: []].append(b)
    grafo[b, default: []].append(a)
}

func crearGrafo(futuro: Bool) -> Grafo {

    var grafo: Grafo = [:]

    for i in 0..<(nombresL1.count - 1) {

        unir(
            nombresL1[i],
            nombresL1[i + 1],
            &grafo
        )
    }

    for i in 0..<(nombresMet.count - 1) {

        unir(
            met(nombresMet[i]),
            met(nombresMet[i + 1]),
            &grafo
        )
    }

    for (a, b) in enlacesSuperficieL1Met {

        unir(a, b, &grafo)
    }

    for i in 0..<(nombresL2.count - 1) {

        let a = l2(nombresL2[i])
        let b = l2(nombresL2[i + 1])

        if futuro {

            unir(a, b, &grafo)

        } else if
            estaciones[a]?.estado == .operativa &&
            estaciones[b]?.estado == .operativa {

            unir(a, b, &grafo)
        }
    }

    if futuro {

        unir(
            "Gamarra",
            "28 de Julio (L1 futura)",
            &grafo
        )

        unir(
            "28 de Julio (L1 futura)",
            "Grau",
            &grafo
        )

        unir(
            "28 de Julio (L1 futura)",
            l2("28 de Julio"),
            &grafo
        )

        unir(
            l2("Estación Central"),
            met("Central"),
            &grafo
        )

        for i in 0..<(nombresL4.count - 1) {

            unir(
                l4(nombresL4[i]),
                l4(nombresL4[i + 1]),
                &grafo
            )
        }

        unir(
            l2("Carmen de la Legua"),
            l4("Carmen de la Legua"),
            &grafo
        )
    }

    return grafo
}

func bfs(
    _ origen: String,
    _ destino: String,
    _ grafo: Grafo
) -> [String]? {

    var cola = [origen]

    var visitados: Set<String> = [
        origen
    ]

    var anterior: [String: String] = [:]

    while !cola.isEmpty {

        let actual = cola.removeFirst()

        if actual == destino {

            break
        }

        for vecino in grafo[
            actual,
            default: []
        ] {

            if !visitados.contains(vecino) {

                visitados.insert(vecino)

                anterior[vecino] = actual

                cola.append(vecino)
            }
        }
    }

    guard visitados.contains(destino) else {

        return nil
    }

    var camino = [destino]

    var actual = destino

    while let previo = anterior[actual] {

        camino.append(previo)

        actual = previo
    }

    return camino.reversed()
}

func claveRuta(_ texto: String) -> String? {

    if let destino = buscarDestino(texto) {

        return destino.estacion
    }

    return resolver(texto)
}

func minutos(
    _ a: String,
    _ b: String
) -> Int {

    guard
        let origen = estaciones[a],
        let destino = estaciones[b]
    else {

        return 4
    }

    if origen.linea != destino.linea {

        if
            origen.linea == .l1 &&
            destino.linea == .met ||
            origen.linea == .met &&
            destino.linea == .l1 {

            return 15
        }

        return 7
    }

    switch origen.linea {

    case .l1:
        return 3

    case .l2:
        return 2

    case .l4:
        return 3

    case .met:
        return 4
    }
}

func imprimirRuta(
    _ camino: [String],
    _ titulo: String
) {

    var total = 0

    print("\n===== \(titulo) =====")

    for i in camino.indices {

        guard let estacion =
                estaciones[camino[i]]
        else {

            continue
        }

        if i == 0 {

            print(
                "INICIO: \(estacion.nombre) [\(estacion.linea.rawValue)]"
            )

        } else if i == camino.count - 1 {

            print(
                "DESTINO: \(estacion.nombre) [\(estacion.linea.rawValue)]"
            )

        } else {

            print(
                "↓ \(estacion.nombre) [\(estacion.linea.rawValue)]"
            )
        }

        if i < camino.count - 1 {

            guard let siguiente =
                    estaciones[camino[i + 1]]
            else {

                continue
            }

            total += minutos(
                camino[i],
                camino[i + 1]
            )

            if estacion.linea != siguiente.linea {

                print(
                    "   CAMBIO: \(estacion.linea.rawValue) -> \(siguiente.linea.rawValue)"
                )
            }
        }
    }

    print(
        "\nTiempo estimado: \(total) minutos"
    )
}

func resumenConexion(
    _ camino: [String]
) {

    guard camino.count > 1 else {

        return
    }

    var cambios: [
        (
            String,
            String,
            String
        )
    ] = []

    for i in 0..<(camino.count - 1) {

        guard
            let actual = estaciones[camino[i]],
            let siguiente = estaciones[camino[i + 1]]
        else {

            continue
        }

        if actual.linea != siguiente.linea {

            cambios.append(
                (
                    actual.linea.rawValue,
                    siguiente.linea.rawValue,
                    siguiente.nombre
                )
            )
        }
    }

    if cambios.isEmpty {

        if
            let primera = camino.first,
            let estacion = estaciones[primera] {

            print(
                "Puedes llegar usando solamente \(estacion.linea.rawValue)."
            )
        }

    } else {

        print("\nLíneas necesarias:")

        for cambio in cambios {

            print(
                "- \(cambio.0) -> \(cambio.1) cerca de \(cambio.2)"
            )
        }
    }
}

func progresoViaje(
    _ camino: [String]
) {

    guard !camino.isEmpty else {

        return
    }

    print(
        "\n¿En qué estación del recorrido estás actualmente?"
    )

    for (i, clave) in camino.enumerated() {

        if let estacion = estaciones[clave] {

            print(
                "\(i + 1). \(estacion.nombre)"
            )
        }
    }

    guard
        let texto = readLine(),
        let posicion = Int(texto),
        (1...camino.count).contains(posicion)
    else {

        print(
            "No se registró una posición válida."
        )

        return
    }

    let indice = posicion - 1

    let restantes =
        Array(camino[indice...])

    var tiempo = 0

    if restantes.count > 1 {

        for i in 0..<(restantes.count - 1) {

            tiempo += minutos(
                restantes[i],
                restantes[i + 1]
            )
        }
    }

    print("\n===== PROGRESO DEL VIAJE =====")

    print(
        "Estación actual: \(estaciones[camino[indice]]?.nombre ?? camino[indice])"
    )

    print(
        "Faltan \(restantes.count - 1) estaciones."
    )

    print(
        "Tiempo restante aproximado: \(tiempo) minutos."
    )

    if let destino = camino.last {

        print(
            "Destino: \(estaciones[destino]?.nombre ?? destino)"
        )

        resumenConexion(restantes)

        experienciaAlLlegar(destino)
    }
}

func opcionRuta() {

    print("Ingrese la estación de origen:")

    guard
        let textoOrigen = readLine(),
        let origen = claveRuta(textoOrigen)
    else {

        print("Origen no identificado.")

        return
    }

    print("Ingrese estación o destino:")

    guard
        let textoDestino = readLine(),
        let destino = claveRuta(textoDestino)
    else {

        print("Destino no identificado.")

        return
    }

    let grafoActual =
        crearGrafo(futuro: false)

    if let camino =
        bfs(
            origen,
            destino,
            grafoActual
        ) {

        imprimirRuta(
            camino,
            "RUTA ACTUAL"
        )

        resumenConexion(camino)

        progresoViaje(camino)

        return
    }

    let grafoFuturo =
        crearGrafo(futuro: true)

    if let camino =
        bfs(
            origen,
            destino,
            grafoFuturo
        ) {

        print(
            "No existe una ruta completamente operativa."
        )

        imprimirRuta(
            camino,
            "RUTA FUTURA"
        )

        resumenConexion(camino)

        progresoViaje(camino)

        return
    }

    print("No se encontró una ruta.")
}

func opcionServicio() {

    print("Ingrese estación:")

    guard let texto = readLine() else {

        return
    }

    let resultados = buscar(texto)

    guard
        !resultados.isEmpty,
        let clave = elegir(resultados),
        let estacion = estaciones[clave]
    else {

        print("Estación no encontrada.")

        return
    }

    guard estacion.estado == .operativa else {

        print(
            "\(estacion.nombre) todavía no tiene servicio operativo."
        )

        return
    }

    var frecuencia = 0
    var espera = 0
    var tipo = ""

    switch estacion.linea {

    case .l1:

        frecuencia =
            Int.random(in: 5...12)

        espera =
            Int.random(in: 1...frecuencia)

        tipo = "tren"

    case .l2:

        frecuencia =
            Int.random(in: 5...9)

        espera =
            Int.random(in: 1...frecuencia)

        tipo = "tren"

    case .met:

        frecuencia =
            Int.random(in: 3...7)

        espera =
            Int.random(in: 1...frecuencia)

        tipo = "bus"

    case .l4:

        print(
            "Ramal Línea 4 en construcción."
        )

        return
    }

    print(
        "Próximo \(tipo): aproximadamente \(espera) minutos."
    )

    print(
        "Siguiente: aproximadamente \(espera + frecuencia) minutos."
    )
}

func tarifaSimulada(
    origen: String,
    destino: String
) -> Double {

    guard
        let estacionOrigen = estaciones[origen],
        let estacionDestino = estaciones[destino]
    else {

        return 1.50
    }

    if estacionOrigen.linea ==
        estacionDestino.linea {

        switch estacionOrigen.linea {

        case .l1:
            return 1.50

        case .l2:
            return 1.40

        case .met:
            return 3.20

        case .l4:
            return 1.50
        }
    }

    return 4.00
}

func mostrarTarjeta() {

    print(
        "\n===== TARJETA DE TRANSPORTE ====="
    )

    print(
        "Número: \(tarjetaUsuario.numero)"
    )

    print(
        String(
            format:
                "Saldo actual: S/ %.2f",
            tarjetaUsuario.saldo
        )
    )

    print(
        "Viajes realizados: \(tarjetaUsuario.viajesRealizados)"
    )

    print(
        "Las tarifas son simuladas para demostrar el funcionamiento del programa."
    )
}

func recargarTarjeta() {

    mostrarTarjeta()

    print(
        "\nIngrese el monto de recarga:"
    )

    guard
        let texto = readLine(),
        let monto = Double(texto)
    else {

        print("Monto inválido.")

        return
    }

    if tarjetaUsuario.recargar(monto) {

        print(
            String(
                format:
                    "Recarga realizada."
            )
        )

        print(
            String(
                format:
                    "Nuevo saldo: S/ %.2f",
                tarjetaUsuario.saldo
            )
        )

    } else {

        print(
            "El monto debe ser mayor que cero."
        )
    }
}

func simularCobro() {

    print(
        "Ingrese estación de origen:"
    )

    guard
        let textoOrigen = readLine(),
        let origen =
            claveRuta(textoOrigen)
    else {

        print(
            "Origen no identificado."
        )

        return
    }

    print(
        "Ingrese estación o destino:"
    )

    guard
        let textoDestino = readLine(),
        let destino =
            claveRuta(textoDestino)
    else {

        print(
            "Destino no identificado."
        )

        return
    }

    let tarifa =
        tarifaSimulada(
            origen: origen,
            destino: destino
        )

    print(
        String(
            format:
                "Tarifa simulada: S/ %.2f",
            tarifa
        )
    )

    if tarjetaUsuario.cobrar(tarifa) {

        print(
            "Cobro realizado correctamente."
        )

        print(
            String(
                format:
                    "Saldo restante: S/ %.2f",
                tarjetaUsuario.saldo
            )
        )

    } else {

        print(
            "Saldo insuficiente."
        )

        print(
            String(
                format:
                    "Saldo disponible: S/ %.2f",
                tarjetaUsuario.saldo
            )
        )
    }
}

func menuTarjeta() {

    var volver = false

    while !volver {

        print("""
        
        ===== GESTIÓN DE TARJETA =====

        1. Ver saldo actual
        2. Recargar tarjeta
        3. Simular cobro de viaje
        0. Volver

        Opción:
        """)

        switch readLine() {

        case "1":

            mostrarTarjeta()

        case "2":

            recargarTarjeta()

        case "3":

            simularCobro()

        case "0":

            volver = true

        default:

            print("Opción inválida.")
        }
    }
}

func menu() {

    print("""
    
    ============== METRO LIMA GO ==============

    1. Buscar estación
    2. Ver estaciones por línea
    3. Ver cruces
    4. Consultar destino
    5. Planificar viaje
    6. Próximo servicio
    7. Gestionar tarjeta de transporte
    0. Salir

    Opción:
    """)
}

var activo = true

while activo {

    menu()

    switch readLine() {

    case "1":
        opcionBuscar()

    case "2":
        opcionLinea()

    case "3":
        cruces()

    case "4":
        opcionDestino()

    case "5":
        opcionRuta()

    case "6":
        opcionServicio()

    case "7":
        menuTarjeta()

    case "0":

        activo = false

        print(
            "Programa finalizado.")

    default:

        print(
            "Opción inválida.")
    }
}

import Foundation

enum Linea: String { case l1 = "Línea 1", l2 = "Línea 2", l4 = "Ramal Línea 4", met = "Metropolitano" }
enum Estado: String { case operativa = "Operativa", construccion = "En construcción", proyectada = "Proyectada" }
enum TipoConexion: String { case intercambio = "Intercambio", metropolitano = "Conexión con Metropolitano" }

struct Conexion {
    let tipo: TipoConexion
    let destino: String
    let estado: Estado
    let detalle: String
}

struct Estacion {
    let codigo, nombre: String
    let linea: Linea
    let estado: Estado
    let ascensor: Bool?
    let accesible: Bool
    let anio: Int?
    var conexiones: [Conexion] = []
    var nota: String = ""
}

struct Destino { let nombre, estacion, detalle: String }

func norm(_ s: String) -> String {
    s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es_PE"))
        .lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
}
func l2(_ s: String) -> String { "\(s) (L2)" }
func l4(_ s: String) -> String { "\(s) (L4)" }
func met(_ s: String) -> String { "\(s) (Metropolitano)" }
func siNo(_ b: Bool) -> String { b ? "Sí" : "No" }
func datoAscensor(_ b: Bool?) -> String { b.map { $0 ? "Sí" : "No" } ?? "No verificado" }

let totalLineasMetro = 6
// Referencias de superficie para acercarse al Metropolitano desde Línea 1.
// NO son intercambios directos; sirven como orientación del prototipo.
let referenciaMetL1: [String: (paradero: String, detalle: String)] = [
    "Cabitos": ("Benavides", "Referencia aproximada por el eje Benavides/Higuereta; requiere transporte complementario."),
    "Angamos": ("Angamos", "Referencia aproximada por la avenida Angamos; requiere transporte complementario."),
    "La Cultura": ("Javier Prado", "Referencia aproximada por el corredor Javier Prado; requiere transporte complementario."),
    "Grau": ("Central", "Integración prevista mediante la Vía Expresa Grau; todavía no es un intercambio directo operativo.")
]

let enlacesSuperficieL1Met = [
    ("Cabitos", met("Benavides")),
    ("Angamos", met("Angamos")),
    ("La Cultura", met("Javier Prado"))
]

// Recomendaciones clave sin llenar el código de casos especiales.
let recomendacionClave: [String: String] = [
    l2("28 de Julio"): "Referencia temporal: Gamarra (Línea 1) mediante traslado peatonal propuesto; el intercambio definitivo L1-L2 será en 28 de Julio.",
    l2("Estación Central"): "Al culminar las obras, conecta directamente con Central del Metropolitano mediante una galería subterránea de ~180 m.",
    "Grau": "No es cruce directo. Como alternativa futura, Ositrán propuso Central (L2/Metropolitano) -> bus -> Grau (L1)."
]

var estaciones: [String: Estacion] = [:]
func guardar(_ clave: String, _ e: Estacion) { estaciones[clave] = e }
func conectar(_ clave: String, _ c: Conexion) {
    guard var e = estaciones[clave] else { return }
    e.conexiones.append(c); estaciones[clave] = e
}

let nombresL1 = ["Villa El Salvador","Parque Industrial","Pumacahua","Villa María","María Auxiliadora","San Juan","Atocongo","Jorge Chávez","Ayacucho","Cabitos","Angamos","San Borja Sur","La Cultura","Arriola","Gamarra","Grau","El Ángel","Presbítero Maestro","Caja de Agua","Pirámide del Sol","Los Jardines","Los Postes","San Carlos","San Martín","Santa Rosa","Bayóvar"]
let sinAscensor: Set<String> = ["Pumacahua","Villa María","María Auxiliadora","San Borja Sur"]

for (i, n) in nombresL1.enumerated() {
    var nota = "Estación operativa de Línea 1."
    if sinAscensor.contains(n) { nota += " Usa salvaescaleras para accesibilidad." }
    if n == "Grau" { nota += " Grau NO conecta directamente con Línea 2; el intercambio L1-L2 corresponde a 28 de Julio." }
    guardar(n, Estacion(codigo: "L1-\(String(format: "%02d", i+1))", nombre: n, linea: .l1,
        estado: .operativa, ascensor: !sinAscensor.contains(n), accesible: true, anio: nil, nota: nota))
}

guardar("28 de Julio (L1 futura)", Estacion(codigo: "L1-FUT-28J", nombre: "28 de Julio", linea: .l1,
    estado: .proyectada, ascensor: true, accesible: true, anio: nil,
    nota: "Futura estación de intercambio con Línea 2. No está operativa."))

let nombresL2 = ["Puerto del Callao","Buenos Aires","Juan Pablo II","Insurgentes","Carmen de la Legua","Óscar R. Benavides","San Marcos","Elio","La Alborada","Tingo María","Parque Murillo","Plaza Bolognesi","Estación Central","Manco Cápac","Cangallo","28 de Julio","Nicolás Ayllón","Circunvalación","San Juan de Dios","Evitamiento","Óvalo Santa Anita","Colectora Industrial","Hermilio Valdizán","Mercado Santa Anita","Vista Alegre","Prolongación Javier Prado","Municipalidad de Ate"]

for (i, n) in nombresL2.enumerated() {
    let num = i + 1, operativa = (20...24).contains(i + 1)
    let etapa1B = (12...19).contains(num) || (25...27).contains(num)
    var nota = operativa
        ? "Etapa 1A habilitada. Horario habitual: 06:00-23:00; usa Tarjeta Interoperable de Transporte (TIT)."
        : etapa1B
            ? "Etapa 1B en construcción (96% de avance promedio reportado en agosto de 2026); operación prevista para 2029."
            : "Etapa 2 en construcción (91% de avance promedio reportado en agosto de 2026); operación prevista para octubre de 2030."
    if n == "28 de Julio" { nota += " Será el intercambio L2-L1; todavía no está operativo." }
    if n == "Estación Central" { nota += " La estación reportó 79% de avance en julio de 2026 y se conectará al Metropolitano mediante una galería subterránea de ~180 m." }
    if n == "Carmen de la Legua" { nota += " Será intercambio con el Ramal Línea 4." }
    guardar(l2(n), Estacion(codigo: "L2-E\(String(format: "%02d", num))", nombre: n, linea: .l2,
        estado: operativa ? .operativa : .construccion, ascensor: true, accesible: true,
        anio: operativa ? nil : (etapa1B ? 2029 : 2030), nota: nota))
}

let nombresL4 = ["Gambetta","Canta Callao","Bocanegra","Aeropuerto","El Olivar","Quilca","Morales Duárez","Carmen de la Legua"]
for (i, n) in nombresL4.enumerated() {
    guardar(l4(n), Estacion(codigo: "L4-R\(String(format: "%02d", i+1))", nombre: n, linea: .l4,
        estado: .construccion, ascensor: true, accesible: true, anio: 2030,
        nota: "Ramal Línea 4 en construcción: 66% de avance reportado en agosto de 2026; operación prevista para octubre de 2030."))
}

let nombresMet = ["Jirón de la Unión","Central","Estadio Nacional","México","Canadá","Javier Prado","Canaval y Moreyra","Aramburú","Angamos","Ricardo Palma","Benavides","28 de Julio"]
for (i, n) in nombresMet.enumerated() {
    var nota = "Estación operativa del Metropolitano incluida como punto estratégico del prototipo."
    if n == "Central" { nota += " Es una de las estaciones más transitadas y su futura conexión directa con Línea 2 está en construcción." }
    if n == "Jirón de la Unión" { nota += " Útil para acceder al Centro Histórico de Lima." }
    if n == "Estadio Nacional" { nota += " Recomendada para llegar al Estadio Nacional del Perú." }
    if n == "Canaval y Moreyra" { nota += " Punto útil para el centro financiero de San Isidro." }
    if n == "Ricardo Palma" { nota += " Punto útil para Parque Kennedy y el centro de Miraflores." }
    if n == "Benavides" || n == "28 de Julio" { nota += " Punto útil para otros sectores de Miraflores." }
    guardar(met(n), Estacion(codigo: "MET-\(String(format: "%02d", i+1))", nombre: n, linea: .met,
        estado: .operativa, ascensor: nil, accesible: true, anio: nil, nota: nota))
}

conectar(l2("28 de Julio"), Conexion(tipo: .intercambio, destino: "28 de Julio (L1 futura)", estado: .construccion, detalle: "Intercambio L2-L1 todavía no operativo."))
conectar("28 de Julio (L1 futura)", Conexion(tipo: .intercambio, destino: l2("28 de Julio"), estado: .construccion, detalle: "Intercambio L1-L2 todavía no operativo."))
conectar(l2("Estación Central"), Conexion(tipo: .metropolitano, destino: met("Central"), estado: .construccion, detalle: "Galería de conexión aún en construcción."))
conectar(l2("Carmen de la Legua"), Conexion(tipo: .intercambio, destino: l4("Carmen de la Legua"), estado: .construccion, detalle: "Futuro intercambio Línea 2 - Ramal Línea 4."))

let destinos: [String: Destino] = [
    "estadio nacional": Destino(nombre: "Estadio Nacional del Perú", estacion: met("Estadio Nacional"), detalle: "Usa el Metropolitano y baja en Estadio Nacional."),
    "miraflores": Destino(nombre: "Miraflores", estacion: met("Ricardo Palma"), detalle: "Ricardo Palma es una opción práctica para Parque Kennedy y el centro de Miraflores; según el punto exacto también pueden convenir Benavides o 28 de Julio."),
    "parque kennedy": Destino(nombre: "Parque Kennedy", estacion: met("Ricardo Palma"), detalle: "Baja en Ricardo Palma y continúa a pie hacia Parque Kennedy."),
    "centro de lima": Destino(nombre: "Centro Histórico de Lima", estacion: met("Jirón de la Unión"), detalle: "Jirón de la Unión es una estación útil para el Centro Histórico; para Centro Cívico conviene Central."),
    "centro historico": Destino(nombre: "Centro Histórico de Lima", estacion: met("Jirón de la Unión"), detalle: "Jirón de la Unión es una estación útil para el Centro Histórico; para Centro Cívico conviene Central."),
    "centro civico": Destino(nombre: "Centro Cívico", estacion: met("Central"), detalle: "La Estación Central del Metropolitano es la opción directa para la zona del Centro Cívico."),
    "san isidro": Destino(nombre: "Centro financiero de San Isidro", estacion: met("Canaval y Moreyra"), detalle: "Canaval y Moreyra es un punto útil para el centro financiero de San Isidro."),
    "gamarra": Destino(nombre: "Emporio Comercial de Gamarra", estacion: "Gamarra", detalle: "Usa Línea 1 y baja en Gamarra, la estación con mayor demanda de Línea 1 durante los primeros meses de 2026."),
    "museo de la nacion": Destino(nombre: "Museo de la Nación / zona Cultura", estacion: "La Cultura", detalle: "Usa Línea 1 y baja en La Cultura."),
    "aeropuerto": Destino(nombre: "Aeropuerto Internacional Jorge Chávez", estacion: l4("Aeropuerto"), detalle: "La futura estación Aeropuerto del Ramal Línea 4 aún está en construcción.")
]

func buscar(_ texto: String) -> [(String, Estacion)] {
    let q = norm(texto)
    return estaciones.filter { norm($0.key).contains(q) || norm($0.value.nombre).contains(q) || norm($0.value.codigo).contains(q) }
        .sorted { $0.value.nombre < $1.value.nombre }
}

func resolver(_ texto: String) -> String? {
    let q = norm(texto)
    if let k = estaciones.keys.first(where: { norm($0) == q }) { return k }
    let exactas = estaciones.filter { norm($0.value.nombre) == q }
    if exactas.count == 1 { return exactas.first?.key }
    let r = buscar(texto); return r.count == 1 ? r[0].0 : nil
}

func elegir(_ r: [(String, Estacion)]) -> String? {
    if r.count == 1 { return r[0].0 }
    for (i, x) in r.enumerated() { print("\(i+1). \(x.1.nombre) - \(x.1.linea.rawValue) - \(x.1.estado.rawValue)") }
    guard let s = readLine(), let n = Int(s), (1...r.count).contains(n) else { return nil }
    return r[n-1].0
}

func mostrar(_ clave: String) {
    guard let e = estaciones[clave] else { return }
    print("\n=== \(e.nombre) ===")
    print("Código: \(e.codigo) | Sistema: \(e.linea.rawValue) | Estado: \(e.estado.rawValue)")
    print("Accesible: \(siNo(e.accesible)) | Ascensor: \(datoAscensor(e.ascensor))")
    if let a = e.anio { print("Operación prevista/referencial: \(a)") }
    print("Nota: \(e.nota)")
    if let r = recomendacionClave[clave] { print("Recomendación: \(r)") }

    if e.linea == .l1, let ref = referenciaMetL1[e.nombre] {
        print("Metropolitano de referencia: \(ref.paradero)")
        print("  \(ref.detalle)")
    } else if e.linea == .l2 {
        if e.nombre == "Estación Central" {
            print("Metropolitano de referencia: Central | conexión directa futura, actualmente en construcción.")
        } else {
            print("Metropolitano: sin cruce directo en esta estación; Estación Central será el intercambio principal.")
        }
    }

    if e.conexiones.isEmpty { print("Conexiones especiales: ninguna registrada.") }
    for c in e.conexiones { print("- \(c.tipo.rawValue) -> \(c.destino) [\(c.estado.rawValue)]\n  \(c.detalle)") }
}

func opcionBuscar() {
    print("Estación o parte del nombre:")
    guard let t = readLine(), !norm(t).isEmpty else { print("Entrada inválida."); return }
    let r = buscar(t); guard !r.isEmpty else { print("No se encontraron resultados."); return }
    if let k = elegir(r) { mostrar(k) }
}

func listar(_ linea: Linea) {
    let lista = estaciones.values.filter { $0.linea == linea }.sorted { $0.codigo < $1.codigo }
    print("\n=== \(linea.rawValue) ===")
    for e in lista {
        print("\(e.codigo) | \(e.nombre) | \(e.estado.rawValue) | Ascensor: \(datoAscensor(e.ascensor))\(e.anio.map { " | prevista: \($0)" } ?? "")")
    }
    if linea == .l1 {
        print("\nAccesibilidad: 26 estaciones accesibles; Pumacahua, Villa María, María Auxiliadora y San Borja Sur usan salvaescaleras en lugar de ascensor.")
        print("Referencias hacia Metropolitano: Cabitos->Benavides | Angamos->Angamos | La Cultura->Javier Prado. Son conexiones por superficie, NO intercambios directos.")
    }
    if linea == .l2 {
        print("\nResumen actual: 27 estaciones | 5 operativas | 22 en construcción | todas diseñadas con ascensores y accesibilidad.")
        print("Cruces: 28 de Julio -> Línea 1 | Estación Central -> Metropolitano | Carmen de la Legua -> Ramal L4")
    }
    if linea == .met {
        print("Puntos útiles: Jirón de la Unión/Centro Histórico | Central/Centro Cívico | Estadio Nacional | Canaval y Moreyra/San Isidro | Ricardo Palma, Benavides y 28 de Julio/Miraflores.")
        print("Nota: es un subconjunto estratégico del prototipo; servicios y paradas exactas dependen de la ruta y horario.")
    }
}

func opcionLinea() {
    print("1.Línea 1  2.Línea 2  3.Ramal L4  4.Metropolitano")
    switch readLine() { case "1": listar(.l1); case "2": listar(.l2); case "3": listar(.l4); case "4": listar(.met); default: print("Opción inválida.") }
}

func cruces() {
    print("""
    \n=== CRUCES CLAVE ===
    1. 28 de Julio: Línea 1 <-> Línea 2 | EN CONSTRUCCIÓN
       Alternativa temporal propuesta: traslado peatonal hacia Gamarra (Línea 1).
    2. Estación Central: Línea 2 <-> Metropolitano | EN CONSTRUCCIÓN
       Conexión directa futura mediante galería subterránea de ~180 m.
    3. Carmen de la Legua: Línea 2 <-> Ramal Línea 4 | EN CONSTRUCCIÓN
    4. Grau: NO es intercambio directo. Existe una propuesta indirecta Central -> Metropolitano -> bus -> Grau.
    """)
}

func buscarDestino(_ t: String) -> Destino? {
    let q = norm(t)
    return destinos[q] ?? destinos.first { q.contains($0.key) || $0.key.contains(q) }?.value
}

func opcionDestino() {
    print("Destino (Estadio Nacional / Miraflores / Centro de Lima / San Isidro / Gamarra / Aeropuerto):")
    guard let t = readLine(), let d = buscarDestino(t) else { print("Destino no registrado."); return }
    print("Destino: \(d.nombre)\nEstación/paradero: \(d.estacion)\n\(d.detalle)")
    if let e = estaciones[d.estacion] { print("Estado: \(e.estado.rawValue)"); if e.estado != .operativa { print("ADVERTENCIA: infraestructura aún no operativa.") } }
}

typealias Grafo = [String: [String]]
func unir(_ a: String, _ b: String, _ g: inout Grafo) { g[a, default: []].append(b); g[b, default: []].append(a) }

func crearGrafo(futuro: Bool) -> Grafo {
    var g: Grafo = [:]
    for i in 0..<nombresL1.count-1 { unir(nombresL1[i], nombresL1[i+1], &g) }
    for i in 0..<nombresMet.count-1 { unir(met(nombresMet[i]), met(nombresMet[i+1]), &g) }
    // Enlaces de superficie para orientar viajes L1 -> Metropolitano. No son intercambios directos.
    for (a, b) in enlacesSuperficieL1Met { unir(a, b, &g) }
    for i in 0..<nombresL2.count-1 {
        let a = l2(nombresL2[i]), b = l2(nombresL2[i+1])
        if futuro || (estaciones[a]?.estado == .operativa && estaciones[b]?.estado == .operativa) { unir(a, b, &g) }
    }
    if futuro {
        unir("Gamarra", "28 de Julio (L1 futura)", &g); unir("28 de Julio (L1 futura)", "Grau", &g)
        unir("28 de Julio (L1 futura)", l2("28 de Julio"), &g)
        unir(l2("Estación Central"), met("Central"), &g)
        for i in 0..<nombresL4.count-1 { unir(l4(nombresL4[i]), l4(nombresL4[i+1]), &g) }
        unir(l2("Carmen de la Legua"), l4("Carmen de la Legua"), &g)
    }
    return g
}

func bfs(_ origen: String, _ destino: String, _ g: Grafo) -> [String]? {
    var cola = [origen], visitados: Set<String> = [origen], anterior: [String:String] = [:]
    while !cola.isEmpty {
        let actual = cola.removeFirst(); if actual == destino { break }
        for v in g[actual, default: []] where !visitados.contains(v) { visitados.insert(v); anterior[v] = actual; cola.append(v) }
    }
    guard visitados.contains(destino) else { return nil }
    var camino = [destino], actual = destino
    while let p = anterior[actual] { camino.append(p); actual = p }
    return camino.reversed()
}

func claveRuta(_ t: String) -> String? { buscarDestino(t)?.estacion ?? resolver(t) }

func origenInteractivo(_ texto: String) -> String? {
    let q = norm(texto)
    let linea: Linea? = q == "linea 1" ? .l1 : q == "linea 2" ? .l2 : q == "metropolitano" ? .met : nil
    guard let l = linea else { return claveRuta(texto) }
    let lista = estaciones.values.filter { $0.linea == l }.sorted { $0.codigo < $1.codigo }
    print("¿En qué estación de \(l.rawValue) estás?")
    for (i,e) in lista.enumerated() { print("\(i+1). \(e.nombre) - \(e.estado.rawValue)") }
    guard let x = readLine(), let n = Int(x), (1...lista.count).contains(n) else { return nil }
    let elegida = lista[n-1]
    return estaciones.first { $0.value.codigo == elegida.codigo }?.key
}
func minutos(_ a: String, _ b: String) -> Int {
    guard let x = estaciones[a], let y = estaciones[b] else { return 4 }
    if x.linea != y.linea {
        if (x.linea == .l1 && y.linea == .met) || (x.linea == .met && y.linea == .l1) { return 15 }
        return 7
    }
    switch x.linea { case .l1: return 3; case .l2: return 2; case .l4: return 3; case .met: return 4 }
}

func imprimirRuta(_ c: [String], _ titulo: String) {
    var total = 0
    print("\n=== \(titulo) ===")
    for i in c.indices {
        guard let e = estaciones[c[i]] else { continue }
        print("\(i == 0 ? "INICIO" : i == c.count-1 ? "DESTINO" : "↓") \(e.nombre) [\(e.linea.rawValue)] - \(e.estado.rawValue)")
        if let r = recomendacionClave[c[i]] { print("   SUGERENCIA: \(r)") }
        if i < c.count-1, let sig = estaciones[c[i+1]] {
            total += minutos(c[i], c[i+1])
            if e.linea != sig.linea {
                if (e.linea == .l1 && sig.linea == .met) || (e.linea == .met && sig.linea == .l1) {
                    print("   CONEXIÓN POR SUPERFICIE: trasládate hacia \(sig.nombre) del Metropolitano. No es intercambio directo; tiempo simulado ~15 min.")
                } else {
                    print("   TRANSBORDO: cambia de \(e.linea.rawValue) a \(sig.linea.rawValue) en \(sig.nombre).")
                }
            }
        }
    }
    print("Tiempo estimado: ~\(total) min")
    if c.contains(where: { estaciones[$0]?.estado != .operativa }) { print("ADVERTENCIA: ruta referencial con infraestructura no operativa.") }
}

func opcionRuta() {
    print("Origen (estación o sistema: Línea 1 / Línea 2 / Metropolitano):")
    guard let o = readLine(), let origen = origenInteractivo(o) else { print("Origen no identificado."); return }
    print("Destino (ej.: Miraflores, Centro de Lima, Estadio Nacional):")
    guard let d = readLine(), let destino = claveRuta(d) else { print("Destino no identificado."); return }
    if estaciones[origen]?.estado != .operativa { print("La estación de origen aún no está operativa; se buscará una ruta futura/referencial.") }
    if let c = bfs(origen, destino, crearGrafo(futuro: false)) { imprimirRuta(c, "RUTA ACTUAL") }
    else if let c = bfs(origen, destino, crearGrafo(futuro: true)) { print("No existe ruta integrada con la red operativa registrada."); imprimirRuta(c, "RUTA FUTURA / REFERENCIAL") }
    else { print("No se encontró una ruta.") }
}

func opcionServicio() {
    print("Estación:")
    guard let t = readLine() else { return }; let r = buscar(t)
    guard !r.isEmpty, let k = elegir(r), let e = estaciones[k] else { print("Estación no encontrada."); return }
    guard e.estado == .operativa else { print("\(e.nombre): \(e.estado.rawValue). Aún no tiene servicio operativo."); return }
    let espera: Int, frecuencia: Int, tipo: String
    switch e.linea {
    case .l1: frecuencia = Int.random(in: 5...12); espera = Int.random(in: 1...frecuencia); tipo = "tren"
    case .l2: frecuencia = Int.random(in: 5...9); espera = Int.random(in: 1...frecuencia); tipo = "tren"
    case .met: frecuencia = Int.random(in: 3...7); espera = Int.random(in: 1...frecuencia); tipo = "bus"
    case .l4: print("Ramal Línea 4 en construcción."); return
    }
    print("Próximo \(tipo): ~\(espera) min | Siguiente: ~\(espera + frecuencia) min | Frecuencia estimada: ~\(frecuencia) min")
    print("SIMULACIÓN realista para el prototipo; no es una API oficial en tiempo real.")
}

let requisitos = [
    "RF-01 Buscar una estación por nombre y mostrar su información de conectividad.",
    "RF-02 Mostrar línea, estado actual, ascensor, accesibilidad y referencia al Metropolitano cuando corresponda.",
    "RF-03 Listar las estaciones de Línea 1, Línea 2, Metropolitano y Ramal L4.",
    "RF-04 Identificar las 27 estaciones de Línea 2 y cuáles están operativas o en construcción.",
    "RF-05 Mostrar cruces de Línea 2 y referencias de conexión por superficie entre Línea 1 y Metropolitano, aclarando cuáles no son intercambios directos.",
    "RF-06 Recomendar estación/paradero para destinos como Estadio Nacional, Centro de Lima, Miraflores, San Isidro, Gamarra y Aeropuerto.",
    "RF-07 Calcular rutas actuales o futuras con BFS y tiempo estimado.",
    "RF-08 Simular próximos servicios solo en estaciones operativas y validar entradas.",
    "RF-09 Reutilizar la lógica posteriormente en una app móvil."
]
func verRequisitos() { print("\n=== REQUERIMIENTOS FUNCIONALES ==="); requisitos.forEach { print("- \($0)") } }

func menu() {
    print("""
    \n================ METRO LIMA GO ================
    1. Buscar estación
    2. Ver estaciones por línea
    3. Ver cruces de Línea 2
    4. Consultar destino
    5. Calcular ruta
    6. Próximo servicio (SIMULADO)
    7. Requerimientos funcionales
    0. Salir
    Red Básica del Metro de Lima: \(totalLineasMetro) líneas.
    Opción:
    """)
}

var activo = true
while activo {
    menu()
    switch readLine() {
    case "1": opcionBuscar(); case "2": opcionLinea(); case "3": cruces(); case "4": opcionDestino()
    case "5": opcionRuta(); case "6": opcionServicio(); case "7": verRequisitos()
    case "0": activo = false; print("Programa finalizado.")
    default: print("Opción inválida.")
    }
}

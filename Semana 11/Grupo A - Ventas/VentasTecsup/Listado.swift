import UIKit

class Listado: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let controles = UIStackView()
    let tabla = UITableView(frame: .zero, style: .insetGrouped)
    let buscador = UISearchBar()
    let vacio = etiqueta("", estilo: .subheadline, color: .secondaryLabel)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        controles.axis = .vertical
        controles.spacing = 8
        controles.isLayoutMarginsRelativeArrangement = true
        controles.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16)
        buscador.searchBarStyle = .minimal
        buscador.delegate = self
        tabla.dataSource = self
        tabla.delegate = self
        tabla.keyboardDismissMode = .onDrag
        vacio.textAlignment = .center
        let columna = UIStackView(arrangedSubviews: [controles, tabla])
        columna.axis = .vertical
        columna.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(columna)
        let seguro = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            columna.topAnchor.constraint(equalTo: seguro.topAnchor),
            columna.leadingAnchor.constraint(equalTo: seguro.leadingAnchor),
            columna.trailingAnchor.constraint(equalTo: seguro.trailingAnchor),
            columna.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
        ])
    }

    func actualizar() {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizar()
    }

    func mostrarFilas(_ cantidad: Int, vacio mensaje: String) {
        vacio.text = mensaje
        tabla.backgroundView = cantidad == 0 ? vacio : nil
        tabla.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { actualizar() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        nil
    }
}

final class Filtros: UIScrollView {
    private let fila = UIStackView()

    init() {
        super.init(frame: .zero)
        showsHorizontalScrollIndicator = false
        fila.spacing = 6
        fila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fila)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44),
            fila.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            fila.centerYAnchor.constraint(equalTo: frameLayoutGuide.centerYAnchor),
            contentLayoutGuide.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor),
        ])
    }

    required init?(coder: NSCoder) { nil }

    func mostrar(_ opciones: [String], seleccion: Int, elegir: @escaping (Int) -> Void) {
        for vista in fila.arrangedSubviews { vista.removeFromSuperview() }
        for (indice, titulo) in opciones.enumerated() {
            var estilo = indice == seleccion ? UIButton.Configuration.filled() : .tinted()
            estilo.title = titulo
            estilo.cornerStyle = .capsule
            let opcion = UIButton(configuration: estilo, primaryAction: UIAction { _ in elegir(indice) })
            if indice == seleccion { opcion.accessibilityTraits.insert(.selected) }
            fila.addArrangedSubview(opcion)
        }
    }
}

func filaDetalle(_ titulo: String, _ detalle: String, valor: String? = nil,
                 color: UIColor = .label, icono: String? = nil, tachada: Bool = false,
                 editable: Bool = false) -> UITableViewCell {
    let celda = UITableViewCell()
    var contenido = UIListContentConfiguration.subtitleCell()
    if tachada {
        contenido.attributedText = NSAttributedString(string: titulo, attributes: [.strikethroughStyle: 1])
    } else {
        contenido.text = titulo
    }
    contenido.secondaryText = detalle
    contenido.image = icono.flatMap { UIImage(systemName: $0) }
    contenido.imageProperties.tintColor = color
    celda.contentConfiguration = contenido
    if let valor {
        let texto = etiqueta(valor, estilo: .subheadline, color: color)
        texto.textAlignment = .right
        texto.sizeToFit()
        celda.accessoryView = texto
        celda.accessibilityLabel = [titulo, detalle, valor].joined(separator: ", ")
    } else if editable {
        celda.accessoryType = .disclosureIndicator
    }
    celda.selectionStyle = editable ? .default : .none
    return celda
}

func accionDeslizante(_ titulo: String, accion: @escaping () -> Bool) -> UISwipeActionsConfiguration {
    let accion = UIContextualAction(style: .destructive, title: titulo) { _, _, terminar in
        terminar(accion())
    }
    let configuracion = UISwipeActionsConfiguration(actions: [accion])
    configuracion.performsFirstActionWithFullSwipe = false
    return configuracion
}

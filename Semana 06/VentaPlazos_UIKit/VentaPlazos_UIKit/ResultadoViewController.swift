import UIKit

final class ResultadoViewController: UIViewController {
    var venta: VentaModel!

    @IBOutlet private weak var subtotalLabel: UILabel!
    @IBOutlet private weak var igvLabel: UILabel!
    @IBOutlet private weak var baseLabel: UILabel!
    @IBOutlet private weak var interesesLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var cuotaLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        subtotalLabel.text = String(format: "S/. %.2f", venta.subtotal)
        igvLabel.text = String(format: "S/. %.2f", venta.igv)
        baseLabel.text = String(format: "S/. %.2f", venta.base)
        interesesLabel.text = String(format: "S/. %.2f", venta.intereses)
        totalLabel.text = String(format: "S/. %.2f", venta.total)
        cuotaLabel.text = String(format: "S/. %.2f", venta.cuota)
    }
}

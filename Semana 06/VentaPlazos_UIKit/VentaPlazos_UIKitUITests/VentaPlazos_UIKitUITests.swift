import XCTest

final class VentaPlazos_UIKitUITests: XCTestCase {
    func testCalculoYResultado() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["NUEVA VENTA"].waitForExistence(timeout: 5))

        let datos = [
            ("Ej. Refrigeradora", "Refrigeradora"),
            ("Ej. 1200.00", "1200"),
            ("Ej. 2", "2"),
            ("Ej. 12", "12"),
            ("Ej. 2", "2")
        ]
        for (index, dato) in datos.enumerated() {
            let campo = app.textFields.matching(identifier: dato.0).element(boundBy: index == 4 ? 1 : 0)
            campo.tap()
            campo.typeText(dato.1)
        }
        app.toolbars.buttons["Listo"].tap()

        let formulario = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        formulario.name = "Venta formulario"
        formulario.lifetime = .keepAlways
        add(formulario)

        app.buttons["Calcular"].tap()
        XCTAssertTrue(app.staticTexts["RESULTADO"].waitForExistence(timeout: 5))
        for valor in ["S/. 2400.00", "S/. 432.00", "S/. 2832.00",
                      "S/. 679.68", "S/. 3511.68", "S/. 292.64"] {
            XCTAssertTrue(app.staticTexts[valor].exists, "Falta \(valor)")
        }

        let resultado = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        resultado.name = "Venta resultado"
        resultado.lifetime = .keepAlways
        add(resultado)
    }

    func testDatosIncompletosMuestranAviso() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Calcular"].tap()
        XCTAssertTrue(app.alerts["Revisa los datos"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["RESULTADO"].exists)
    }
}

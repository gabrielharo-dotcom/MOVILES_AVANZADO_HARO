import XCTest

final class BoletaPagoUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(es)", "-AppleLocale", "es_PE"]
        app.launch()
    }

    private func captura(_ nombre: String) {
        let adjunto = XCTAttachment(screenshot: app.screenshot())
        adjunto.name = nombre
        adjunto.lifetime = .keepAlways
        add(adjunto)
    }

    private func mostrar(_ elemento: XCUIElement) {
        for _ in 0..<6 {
            if elemento.isHittable { return }
            app.swipeUp()
        }
        XCTAssertTrue(elemento.isHittable)
    }

    private func escribir(_ nombre: String, _ valor: String) {
        let campo = app.textFields[nombre]
        mostrar(campo)
        campo.tap()
        campo.typeText(valor)
    }

    private func caso(_ numero: Int, sueldo: String, dias: String, hijos: Bool, afp: Bool,
                      horas: String? = nil, adelanto: String? = nil, neto: String) {
        escribir("Sueldo básico", sueldo)
        escribir("Días laborados (1 a 30)", dias)
        app.swipeUp() // Desplaza el formulario y descarta el teclado decimal.
        let hijosControl = app.segmentedControls["hijos"]
        mostrar(hijosControl)
        hijosControl.buttons[hijos ? "Sí" : "No"].tap()
        let pension = app.segmentedControls["pension"]
        mostrar(pension)
        pension.buttons[afp ? "AFP" : "ONP"].tap()
        if let horas = horas {
            escribir("Horas extras al 25%", horas)
            escribir("Horas extras al 35%", horas)
        }
        if let adelanto = adelanto { escribir("Adelantos", adelanto) }
        app.swipeUp()
        let boton = app.buttons["calcular"]
        mostrar(boton)
        boton.tap()
        let resultado = app.staticTexts["neto"]
        mostrar(resultado)
        XCTAssertEqual(resultado.label, "S/ " + neto)
        captura("caso-\(numero)-resultado")
    }

    func testCaso1() {
        captura("formulario")
        caso(1, sueldo: "2500", dias: "30", hijos: false, afp: false, neto: "2,175.00")
    }

    func testCaso2() {
        caso(2, sueldo: "1800", dias: "27", hijos: true, afp: false, neto: "1,516.41")
    }

    func testCaso3() {
        caso(3, sueldo: "3000", dias: "30", hijos: true, afp: true, horas: "4", adelanto: "200", neto: "2,631.73")
    }

    func testCaso4() {
        caso(4, sueldo: "4200", dias: "24", hijos: true, afp: true, horas: "2", adelanto: "100", neto: "3,011.17")
    }

    func testValidacion() {
        let boton = app.buttons["calcular"]
        mostrar(boton)
        boton.tap()
        let error = app.staticTexts["error-validacion"]
        mostrar(error)
        XCTAssertEqual(error.label, "El sueldo básico debe ser un número mayor que cero.")
        XCTAssertFalse(app.staticTexts["neto"].exists)
        captura("validacion")
    }
}

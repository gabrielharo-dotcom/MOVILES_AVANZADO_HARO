import XCTest

final class Prestamos_UIKitUITests: XCTestCase {
    func testCuotaYTotalConInteres() {
        let app = XCUIApplication()
        app.launch()

        let fields = app.textFields
        XCTAssertEqual(fields.count, 3)
        enter("10000", in: fields.element(boundBy: 0))
        enter("12", in: fields.element(boundBy: 1))
        enter("1", in: fields.element(boundBy: 2))
        app.buttons["Calcular préstamo"].tap()

        let monthly = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH %@", "Cuota mensual:")
        ).firstMatch
        let total = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH %@", "Total a pagar:")
        ).firstMatch
        XCTAssertTrue(monthly.waitForExistence(timeout: 5))
        XCTAssertEqual(value(of: monthly), "888.49")
        XCTAssertEqual(value(of: total), "10661.85")

        let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        screenshot.name = "Calculadora de prestamos con resultado"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    func testInteresCeroYDatosInvalidos() {
        let app = XCUIApplication()
        app.launch()

        let fields = app.textFields
        enter("1200", in: fields.element(boundBy: 0))
        enter("0", in: fields.element(boundBy: 1))
        enter("1", in: fields.element(boundBy: 2))
        app.buttons["Calcular préstamo"].tap()

        let monthly = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH %@", "Cuota mensual:")
        ).firstMatch
        let total = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH %@", "Total a pagar:")
        ).firstMatch
        XCTAssertEqual(value(of: monthly), "100.00")
        XCTAssertEqual(value(of: total), "1200.00")

        let capital = fields.element(boundBy: 0)
        capital.tap()
        capital.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 4) + "0")
        app.buttons["Calcular préstamo"].tap()
        XCTAssertTrue(app.staticTexts["Revisa los datos ingresados."].waitForExistence(timeout: 5))
    }

    private func enter(_ value: String, in field: XCUIElement) {
        field.tap()
        field.typeText(value)
    }

    private func value(of label: XCUIElement) -> String {
        let text = label.label.components(separatedBy: ": ").last ?? ""
        return text.replacingOccurrences(of: ",", with: ".")
    }
}

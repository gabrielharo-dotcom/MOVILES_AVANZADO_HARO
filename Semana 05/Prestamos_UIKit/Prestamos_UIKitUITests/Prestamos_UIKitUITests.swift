import XCTest

final class Prestamos_UIKitUITests: XCTestCase {
    func testLaAplicacionAbre() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["Calculadora de préstamos"].exists)
    }
}

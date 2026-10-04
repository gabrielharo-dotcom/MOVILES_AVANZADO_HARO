import XCTest

final class Navegacion_UIKitUITests: XCTestCase {
    func testPantallaInicial() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["PANTALLA 01"].exists)
    }
}

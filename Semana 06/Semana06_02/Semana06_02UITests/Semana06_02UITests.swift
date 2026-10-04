import XCTest

final class Semana06_02UITests: XCTestCase {
    func testPantallaInicial() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["DATOS DEL CLIENTE"].exists)
    }
}

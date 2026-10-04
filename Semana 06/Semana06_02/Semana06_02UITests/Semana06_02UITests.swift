import XCTest

final class Semana06_02UITests: XCTestCase {
    func testPresentacionModalDeCliente() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["DATOS DEL CLIENTE"].waitForExistence(timeout: 5))

        let formScreenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        formScreenshot.name = "Formulario de cliente"
        formScreenshot.lifetime = .keepAlways
        add(formScreenshot)

        let fields = app.textFields
        XCTAssertEqual(fields.count, 3)
        fields.element(boundBy: 0).tap()
        fields.element(boundBy: 0).typeText("Haro")
        fields.element(boundBy: 1).tap()
        fields.element(boundBy: 1).typeText("Gabriel")
        fields.element(boundBy: 2).tap()
        fields.element(boundBy: 2).typeText("12345678")
        app.buttons["Continuar"].tap()

        XCTAssertTrue(app.staticTexts["DATOS INGRESADOS"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Haro"].exists)
        XCTAssertTrue(app.staticTexts["Gabriel"].exists)
        XCTAssertTrue(app.staticTexts["12345678"].exists)

        let resultScreenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        resultScreenshot.name = "Cliente confirmado en modal"
        resultScreenshot.lifetime = .keepAlways
        add(resultScreenshot)

        app.buttons["Volver"].tap()
        XCTAssertTrue(app.staticTexts["DATOS DEL CLIENTE"].waitForExistence(timeout: 5))
    }

    func testDNIInvalidoMuestraAviso() {
        let app = XCUIApplication()
        app.launch()

        let fields = app.textFields
        fields.element(boundBy: 0).tap()
        fields.element(boundBy: 0).typeText("Haro")
        fields.element(boundBy: 1).tap()
        fields.element(boundBy: 1).typeText("Gabriel")
        fields.element(boundBy: 2).tap()
        fields.element(boundBy: 2).typeText("123")
        app.buttons["Continuar"].tap()

        XCTAssertTrue(app.alerts["Revisa los datos"].waitForExistence(timeout: 5))
    }
}

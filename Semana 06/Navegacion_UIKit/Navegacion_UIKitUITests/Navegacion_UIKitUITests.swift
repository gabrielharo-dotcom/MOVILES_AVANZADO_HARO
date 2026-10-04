import XCTest

final class Navegacion_UIKitUITests: XCTestCase {
    func testNavegacionDeIdaYVuelta() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["PANTALLA 01"].waitForExistence(timeout: 5))

        let firstScreenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        firstScreenshot.name = "Navegacion pantalla 1"
        firstScreenshot.lifetime = .keepAlways
        add(firstScreenshot)

        app.buttons["A Pantalla 2"].tap()
        XCTAssertTrue(app.staticTexts["PANTALLA 02"].waitForExistence(timeout: 5))

        let secondScreenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        secondScreenshot.name = "Navegacion pantalla 2"
        secondScreenshot.lifetime = .keepAlways
        add(secondScreenshot)

        app.navigationBars.buttons["Pantalla 1"].tap()
        XCTAssertTrue(app.staticTexts["PANTALLA 01"].waitForExistence(timeout: 5))
    }
}

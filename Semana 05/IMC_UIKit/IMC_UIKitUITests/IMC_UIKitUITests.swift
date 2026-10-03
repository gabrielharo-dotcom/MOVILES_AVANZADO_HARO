import XCTest

final class IMC_UIKitUITests: XCTestCase {
    func testCalculoIMC() {
        let app = XCUIApplication()
        app.launch()

        let textFields = app.textFields
        XCTAssertEqual(textFields.count, 2)

        let weight = textFields.element(boundBy: 0)
        weight.tap()
        weight.typeText("70")

        let height = textFields.element(boundBy: 1)
        height.tap()
        height.typeText("1.70")

        app.buttons["Mostrar"].tap()
        XCTAssertTrue(app.staticTexts["IMC: 24.22 - Peso normal"].waitForExistence(timeout: 5))

        let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        screenshot.name = "IMC 70 kg y 1.70 m"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}

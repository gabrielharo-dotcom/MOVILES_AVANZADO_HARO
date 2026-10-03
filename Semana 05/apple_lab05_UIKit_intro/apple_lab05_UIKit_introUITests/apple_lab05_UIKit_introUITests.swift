import XCTest

final class apple_lab05_UIKit_introUITests: XCTestCase {
    func testEtiquetasEnHorizontal() {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()

        let title = app.staticTexts["Diseño y Desarrollo de Software"]
        let name = app.staticTexts["Gabriel Haro"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        XCTAssertTrue(name.exists)

        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }
        XCTAssertTrue(title.isHittable)
        XCTAssertTrue(name.isHittable)

        let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        screenshot.name = "Proyecto 1 en horizontal"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}

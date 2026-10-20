import XCTest

final class AppearanceUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func openAppearance() {
        app.buttons["open_appearance_button"].tap()
        XCTAssertTrue(app.staticTexts["appearance_dynamic_label"].waitForExistence(timeout: 5))
    }

    /// CI runs on the default (light) simulator appearance, so the segmented
    /// control drives the status label deterministically.
    func testAppearanceScreenshots() {
        openAppearance()

        let picker = app.segmentedControls["appearance_style_segmented"]

        picker.buttons["Claro"].tap()
        XCTAssertTrue(app.staticTexts["Modo: Claro"].waitForExistence(timeout: 5))
        attachScreenshot(named: "apariencia-claro")

        picker.buttons["Oscuro"].tap()
        XCTAssertTrue(app.staticTexts["Modo: Oscuro"].waitForExistence(timeout: 5))
        attachScreenshot(named: "apariencia-oscuro")
    }

    func testDynamicTypePreviewIsPresent() {
        openAppearance()
        XCTAssertTrue(app.staticTexts["Texto con Dynamic Type"].exists)
        XCTAssertTrue(app.staticTexts["appearance_size_category_label"].exists)
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

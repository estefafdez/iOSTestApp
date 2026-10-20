import XCTest

final class TestAppUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testGreetingUsesTheEnteredName() {
        let nameField = app.textFields["enter_your_name_textbox"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))

        nameField.tap()
        nameField.typeText("Estefania")
        app.buttons["click_button"].tap()

        XCTAssertTrue(app.staticTexts["Hello: Estefania"].waitForExistence(timeout: 5))
    }

    func testSwitchTogglesTheLabel() {
        // The switch starts ON (set in Main.storyboard)
        let stateSwitch = app.switches["switch_button"]
        let label = app.staticTexts["click_switch_button_text"]
        XCTAssertTrue(stateSwitch.waitForExistence(timeout: 5))

        stateSwitch.tap()
        XCTAssertEqual(label.label, "OFF")

        stateSwitch.tap()
        XCTAssertEqual(label.label, "ON")
    }

    func testContentSurvivesBackgroundAndForeground() {
        let nameField = app.textFields["enter_your_name_textbox"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Estefania")
        app.buttons["click_button"].tap()
        XCTAssertTrue(app.staticTexts["Hello: Estefania"].waitForExistence(timeout: 5))

        // Send the app to the background and bring it back
        XCUIDevice.shared.press(.home)
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5))

        app.activate()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
        XCTAssertTrue(app.staticTexts["Hello: Estefania"].exists)
    }
}

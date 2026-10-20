import XCTest

final class FormUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func openForm() {
        app.buttons["open_form_button"].tap()
        XCTAssertTrue(app.textFields["form_email_textbox"].waitForExistence(timeout: 5))
    }

    func testEmptyFormShowsError() {
        openForm()
        app.buttons["form_submit_button"].tap()
        XCTAssertTrue(app.staticTexts["Completa todos los campos"].waitForExistence(timeout: 5))
    }

    func testInvalidEmailShowsError() {
        openForm()
        let email = app.textFields["form_email_textbox"]
        email.tap()
        email.typeText("no-es-un-email")
        let password = app.secureTextFields["form_password_textbox"]
        password.tap()
        password.typeText("password123")
        app.buttons["form_submit_button"].tap()
        XCTAssertTrue(app.staticTexts["El email no tiene un formato válido"].waitForExistence(timeout: 5))
    }

    func testValidFormShowsSuccess() {
        openForm()
        let email = app.textFields["form_email_textbox"]
        email.tap()
        email.typeText("qa@example.com")
        let password = app.secureTextFields["form_password_textbox"]
        password.tap()
        password.typeText("password123")
        app.buttons["form_submit_button"].tap()
        XCTAssertTrue(app.staticTexts["Registro correcto"].waitForExistence(timeout: 5))
    }

    func testFormScreenshots() {
        openForm()
        attachScreenshot(named: "formulario-vacia")

        let email = app.textFields["form_email_textbox"]
        email.tap()
        email.typeText("mal")
        app.buttons["form_submit_button"].tap()
        XCTAssertTrue(app.staticTexts["Completa todos los campos"].waitForExistence(timeout: 5))
        attachScreenshot(named: "formulario-error")
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

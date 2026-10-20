import XCTest

final class ListUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func openList() {
        app.buttons["open_list_button"].tap()
        XCTAssertTrue(app.tables["list_table"].waitForExistence(timeout: 5))
    }

    private func selectScenario(_ title: String) {
        app.segmentedControls["list_scenario_control"].buttons[title].tap()
    }

    func testSuccessScenarioShowsItems() {
        openList()
        XCTAssertTrue(app.staticTexts["Caso de prueba: login"].waitForExistence(timeout: 5))
    }

    func testEmptyScenarioShowsEmptyMessage() {
        openList()
        selectScenario("Vacía")
        XCTAssertTrue(app.staticTexts["La lista está vacía"].waitForExistence(timeout: 5))
    }

    func testErrorScenarioShowsMessageAndRetry() {
        openList()
        selectScenario("Error")
        XCTAssertTrue(app.staticTexts["No se pudo cargar la lista"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["list_retry_button"].exists)
    }

    func testSlowScenarioShowsItemsAfterTheDelay() {
        openList()
        selectScenario("Lenta")
        // The delay is deterministic (2s): items appear after it, not before the load completes
        XCTAssertTrue(app.staticTexts["Caso de prueba: login"].waitForExistence(timeout: 10))
    }

    func testListScreenshots() {
        openList()
        XCTAssertTrue(app.staticTexts["Caso de prueba: login"].waitForExistence(timeout: 5))
        attachScreenshot(named: "lista-exito")

        selectScenario("Error")
        XCTAssertTrue(app.staticTexts["No se pudo cargar la lista"].waitForExistence(timeout: 5))
        attachScreenshot(named: "lista-error")
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

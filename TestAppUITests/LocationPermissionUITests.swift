import XCTest

final class LocationPermissionUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func openLocation() {
        app.buttons["open_location_button"].tap()
        XCTAssertTrue(app.buttons["location_request_button"].waitForExistence(timeout: 5))
    }

    private var knownStatusTexts: [String] {
        return [
            "Permiso sin decidir",
            "Permiso restringido",
            "Permiso denegado",
            "Permiso concedido (en uso)",
            "Permiso concedido (siempre)"
        ]
    }

    /// The status label must always show one of the formatter's known texts,
    /// whatever permission state the simulator is in.
    func testStatusLabelShowsKnownText() {
        openLocation()
        let found = knownStatusTexts.contains { app.staticTexts[$0].waitForExistence(timeout: 2) }
        XCTAssertTrue(found, "status label shows none of the known permission texts")
    }

    /// Runs after testLocationScreenshots (alphabetical order), so the permission
    /// is already granted: the flow only executes when the state is undecided.
    func testRequestPermissionFlow() {
        openLocation()
        if app.staticTexts["Permiso sin decidir"].exists {
            requestPermissionAndAllow()
        }
        XCTAssertTrue(app.staticTexts["Permiso concedido (en uso)"].waitForExistence(timeout: 5))
    }

    /// First test of the class (alphabetical order): CI resets simulator privacy
    /// before the run, so the state here is always undecided -> granted.
    func testLocationScreenshots() {
        openLocation()
        XCTAssertTrue(app.staticTexts["Permiso sin decidir"].waitForExistence(timeout: 5))
        attachScreenshot(named: "ubicacion-sin-decidir")

        requestPermissionAndAllow()

        XCTAssertTrue(app.staticTexts["Permiso concedido (en uso)"].waitForExistence(timeout: 5))
        attachScreenshot(named: "ubicacion-con-permiso")
    }

    /// Requests the permission and accepts the system alert. The alert can take
    /// a moment to appear, so wait for it before tapping the app: interruption
    /// monitors only fire when a UI interaction finds the alert on screen.
    private func requestPermissionAndAllow() {
        allowSystemLocationAlertIfShown()
        app.buttons["location_request_button"].tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        _ = springboard.alerts.firstMatch.waitForExistence(timeout: 5)
        app.tap() // triggers the interruption monitor
    }

    private func allowSystemLocationAlertIfShown() {
        addUIInterruptionMonitor(withDescription: "Location permission alert") { alert in
            let allow = alert.buttons["Allow While Using App"]
            if allow.exists {
                allow.tap()
                return true
            }
            let once = alert.buttons["Allow Once"]
            if once.exists {
                once.tap()
                return true
            }
            let es = alert.buttons["Permitir al usar la app"]
            if es.exists {
                es.tap()
                return true
            }
            return false
        }
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

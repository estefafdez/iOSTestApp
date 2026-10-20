import XCTest

final class FavoritesUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func openFavorites() {
        app.buttons["open_favorites_button"].tap()
        XCTAssertTrue(app.tables["favorites_table"].waitForExistence(timeout: 5))
    }

    private func resetFavorites() {
        app.buttons["favorites_reset_button"].tap()
    }

    func testTappingRowMarksItAsFavorite() {
        openFavorites()
        resetFavorites()
        app.cells["fav_cell_0"].tap()
        XCTAssertEqual(app.cells["fav_cell_0"].value as? String, "favorito")
        XCTAssertTrue(app.staticTexts["1 favorito(s)"].exists)
    }

    func testFavoriteSurvivesRelaunch() {
        openFavorites()
        resetFavorites()
        app.cells["fav_cell_1"].tap()

        app.terminate()
        app.launch()

        openFavorites()
        XCTAssertEqual(app.cells["fav_cell_1"].value as? String, "favorito")
    }

    func testResetClearsFavorites() {
        openFavorites()
        resetFavorites()
        app.cells["fav_cell_0"].tap()
        app.buttons["favorites_reset_button"].tap()
        XCTAssertTrue(app.staticTexts["Sin favoritos"].exists)
        XCTAssertEqual(app.cells["fav_cell_0"].value as? String, "no favorito")
    }

    func testFavoritesScreenshots() {
        openFavorites()
        resetFavorites()
        attachScreenshot(named: "favoritos-vacio")
        app.cells["fav_cell_0"].tap()
        attachScreenshot(named: "favoritos-marcado")
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

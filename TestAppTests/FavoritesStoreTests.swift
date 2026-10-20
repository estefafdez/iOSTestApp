import XCTest
@testable import TestApp

final class FavoritesStoreTests: XCTestCase {

    private var store: FavoritesStore!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "FavoritesStoreTests")
        defaults.removePersistentDomain(forName: "FavoritesStoreTests")
        store = FavoritesStore(defaults: defaults)
    }

    func testStartsEmpty() {
        XCTAssertTrue(store.all().isEmpty)
    }

    func testToggleAddsAndRemoves() {
        XCTAssertTrue(store.toggle("Caso de prueba: login"))
        XCTAssertTrue(store.isFavorite("Caso de prueba: login"))
        XCTAssertFalse(store.toggle("Caso de prueba: login"))
        XCTAssertFalse(store.isFavorite("Caso de prueba: login"))
    }

    func testFavoritesPersistAcrossStoreInstances() {
        store.toggle("Caso de prueba: checkout")
        let reloaded = FavoritesStore(defaults: defaults)
        XCTAssertTrue(reloaded.isFavorite("Caso de prueba: checkout"))
    }

    func testListIsSortedDeterministically() {
        store.toggle("Caso de prueba: registro")
        store.toggle("Caso de prueba: login")
        XCTAssertEqual(store.all(), ["Caso de prueba: login", "Caso de prueba: registro"])
    }

    func testResetClearsEverything() {
        store.toggle("Caso de prueba: login")
        store.reset()
        XCTAssertTrue(store.all().isEmpty)
    }
}

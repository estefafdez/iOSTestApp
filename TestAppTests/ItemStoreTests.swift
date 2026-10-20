import XCTest
@testable import TestApp

final class ItemStoreTests: XCTestCase {

    func testSuccessScenarioReturnsDemoItems() {
        switch ItemStore.load(scenario: .success) {
        case .items(let items):
            XCTAssertFalse(items.isEmpty)
        case .failure:
            XCTFail("success scenario must not fail")
        }
    }

    func testSlowScenarioReturnsTheSameItemsAsSuccess() {
        guard case .items(let successItems) = ItemStore.load(scenario: .success),
              case .items(let slowItems) = ItemStore.load(scenario: .slow) else {
            return XCTFail("both scenarios must return items")
        }
        XCTAssertEqual(successItems, slowItems)
    }

    func testEmptyScenarioReturnsNoItems() {
        switch ItemStore.load(scenario: .empty) {
        case .items(let items):
            XCTAssertTrue(items.isEmpty)
        case .failure:
            XCTFail("empty scenario must not fail")
        }
    }

    func testErrorScenarioFailsWithMessage() {
        switch ItemStore.load(scenario: .error) {
        case .items:
            XCTFail("error scenario must fail")
        case .failure(let message):
            XCTAssertEqual(message, "No se pudo cargar la lista")
        }
    }

    func testScenarioTitlesMatchSegmentOrder() {
        XCTAssertEqual(ItemStore.scenarioTitles.count, 4)
        XCTAssertEqual(ItemStore.scenarioTitles[ListScenario.success.rawValue], "Éxito")
        XCTAssertEqual(ItemStore.scenarioTitles[ListScenario.error.rawValue], "Error")
    }
}

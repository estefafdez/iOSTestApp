import XCTest
@testable import TestApp

final class AppearanceTests: XCTestCase {

    func testLightStatusText() {
        XCTAssertEqual(AppearanceStatusFormatter.text(for: .light), "Modo: Claro")
    }

    func testDarkStatusText() {
        XCTAssertEqual(AppearanceStatusFormatter.text(for: .dark), "Modo: Oscuro")
    }

    func testUnspecifiedStatusText() {
        XCTAssertEqual(AppearanceStatusFormatter.text(for: .unspecified), "Modo: Sistema")
    }

    func testScenarioTitles() {
        XCTAssertEqual(AppearanceScenario.all.map { $0.title }, ["Sistema", "Claro", "Oscuro"])
    }

    func testScenarioInterfaceStyleMapping() {
        if #available(iOS 13.0, *) {
            XCTAssertEqual(AppearanceScenario.system.interfaceStyle, .unspecified)
            XCTAssertEqual(AppearanceScenario.light.interfaceStyle, .light)
            XCTAssertEqual(AppearanceScenario.dark.interfaceStyle, .dark)
        }
    }
}

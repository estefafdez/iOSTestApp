import XCTest
import CoreLocation
@testable import TestApp

final class LocationStatusFormatterTests: XCTestCase {

    func testNotDetermined() {
        XCTAssertEqual(LocationStatusFormatter.text(for: .notDetermined), "Permiso sin decidir")
    }

    func testRestricted() {
        XCTAssertEqual(LocationStatusFormatter.text(for: .restricted), "Permiso restringido")
    }

    func testDenied() {
        XCTAssertEqual(LocationStatusFormatter.text(for: .denied), "Permiso denegado")
    }

    func testAuthorizedWhenInUse() {
        XCTAssertEqual(LocationStatusFormatter.text(for: .authorizedWhenInUse), "Permiso concedido (en uso)")
    }

    func testAuthorizedAlways() {
        XCTAssertEqual(LocationStatusFormatter.text(for: .authorizedAlways), "Permiso concedido (siempre)")
    }
}

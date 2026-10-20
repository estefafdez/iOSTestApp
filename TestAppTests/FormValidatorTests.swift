import XCTest
@testable import TestApp

final class FormValidatorTests: XCTestCase {

    func testValidEmailAndPasswordPasses() {
        XCTAssertEqual(FormValidator.validate(email: "qa@example.com", password: "password123"), .valid)
    }

    func testEmptyFieldsAreRejected() {
        XCTAssertEqual(FormValidator.validate(email: "", password: ""), .emptyField)
        XCTAssertEqual(FormValidator.validate(email: "qa@example.com", password: ""), .emptyField)
        XCTAssertEqual(FormValidator.validate(email: "", password: "password123"), .emptyField)
    }

    func testEmailWithoutAtSignIsRejected() {
        XCTAssertEqual(FormValidator.validate(email: "qaexample.com", password: "password123"), .invalidEmail)
    }

    func testEmailWithEmptySidesIsRejected() {
        XCTAssertEqual(FormValidator.validate(email: "@example.com", password: "password123"), .invalidEmail)
        XCTAssertEqual(FormValidator.validate(email: "qa@", password: "password123"), .invalidEmail)
    }

    func testEmailWithTwoAtSignsIsRejected() {
        XCTAssertEqual(FormValidator.validate(email: "qa@@example.com", password: "password123"), .invalidEmail)
    }

    func testEmailWithoutDotInDomainIsRejected() {
        XCTAssertEqual(FormValidator.validate(email: "qa@example", password: "password123"), .invalidEmail)
    }

    func testShortPasswordIsRejected() {
        XCTAssertEqual(FormValidator.validate(email: "qa@example.com", password: "short"), .shortPassword)
    }

    func testPasswordOfMinimumLengthPasses() {
        XCTAssertEqual(FormValidator.validate(email: "qa@example.com", password: "12345678"), .valid)
    }

    func testErrorMessageMatchesEachCase() {
        XCTAssertNil(FormValidator.errorMessage(for: .valid))
        XCTAssertEqual(FormValidator.errorMessage(for: .emptyField), "Completa todos los campos")
        XCTAssertEqual(FormValidator.errorMessage(for: .invalidEmail), "El email no tiene un formato válido")
        XCTAssertEqual(FormValidator.errorMessage(for: .shortPassword), "La contraseña debe tener al menos 8 caracteres")
    }
}

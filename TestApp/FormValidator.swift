import Foundation

/// Pure, UI-independent validator for the lab's registration form.
/// Enums without associated values get `==` for free, even in Swift 4.
enum FormValidationResult {
    case valid
    case emptyField
    case invalidEmail
    case shortPassword
}

struct FormValidator {

    static let minimumPasswordLength = 8

    static func validate(email: String, password: String) -> FormValidationResult {
        if email.isEmpty || password.isEmpty { return .emptyField }
        if !isValidEmail(email) { return .invalidEmail }
        if password.count < minimumPasswordLength { return .shortPassword }
        return .valid
    }

    static func isValidEmail(_ email: String) -> Bool {
        // Deliberately simple and deterministic for the lab:
        // exactly one "@", non-empty sides, and a dot inside the domain.
        let parts = email.components(separatedBy: "@")
        guard parts.count == 2, !parts[0].isEmpty else { return false }
        let domain = parts[1]
        guard domain.contains("."), !domain.hasPrefix("."), !domain.hasSuffix(".") else { return false }
        return true
    }

    static func errorMessage(for result: FormValidationResult) -> String? {
        switch result {
        case .valid:
            return nil
        case .emptyField:
            return "Completa todos los campos"
        case .invalidEmail:
            return "El email no tiene un formato válido"
        case .shortPassword:
            return "La contraseña debe tener al menos 8 caracteres"
        }
    }
}

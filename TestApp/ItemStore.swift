import Foundation

/// Controlled scenarios for the lab's list screen.
/// All data is local and deterministic: no network, no dates, no randomness.
enum ListScenario: Int {
    case success = 0
    case empty = 1
    case error = 2
    case slow = 3
}

/// Result of loading items. Custom enum instead of `Result` because
/// the app target still compiles in Swift 4 mode.
enum ListLoadResult {
    case items([String])
    case failure(String)
}

struct ItemStore {

    /// Artificial delay (seconds) the UI applies for the .slow scenario.
    static let slowScenarioDelay: TimeInterval = 2.0

    static let scenarioTitles = ["Éxito", "Vacía", "Error", "Lenta"]

    private static let demoItems = [
        "Caso de prueba: login",
        "Caso de prueba: registro",
        "Caso de prueba: checkout",
        "Caso de prueba: recuperar contraseña"
    ]

    static func load(scenario: ListScenario) -> ListLoadResult {
        switch scenario {
        case .success, .slow:
            return .items(demoItems)
        case .empty:
            return .items([])
        case .error:
            return .failure("No se pudo cargar la lista")
        }
    }
}

import UIKit

/// Lab scenarios for the appearance screen: follow the system, force light
/// or force dark. Pure mapping so unit tests can cover it without rendering.
enum AppearanceScenario: Int {

    case system = 0
    case light = 1
    case dark = 2

    /// Ordered scenarios for the segmented control.
    static var all: [AppearanceScenario] {
        return [.system, .light, .dark]
    }

    /// Title shown on the scenario picker.
    var title: String {
        switch self {
        case .system:
            return "Sistema"
        case .light:
            return "Claro"
        case .dark:
            return "Oscuro"
        }
    }

    /// Interface style forced by this scenario. `.unspecified` follows the
    /// system. Only meaningful on iOS 13+, where dark mode exists.
    @available(iOS 13.0, *)
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

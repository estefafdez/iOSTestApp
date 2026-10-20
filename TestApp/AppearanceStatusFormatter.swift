import UIKit

/// Maps UIUserInterfaceStyle to a deterministic Spanish label so tests can
/// assert the exact text shown on the appearance lab screen.
enum AppearanceStatusFormatter {

    static func text(for style: UIUserInterfaceStyle) -> String {
        switch style {
        case .light:
            return "Modo: Claro"
        case .dark:
            return "Modo: Oscuro"
        case .unspecified:
            return "Modo: Sistema"
        }
    }
}

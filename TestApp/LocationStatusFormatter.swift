import CoreLocation

/// Maps CLAuthorizationStatus to a deterministic Spanish label so tests
/// can assert the exact text shown on the location lab screen.
enum LocationStatusFormatter {

    static func text(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Permiso sin decidir"
        case .restricted:
            return "Permiso restringido"
        case .denied:
            return "Permiso denegado"
        case .authorizedWhenInUse:
            return "Permiso concedido (en uso)"
        case .authorizedAlways:
            return "Permiso concedido (siempre)"
        }
    }
}

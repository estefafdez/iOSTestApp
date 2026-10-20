import UIKit
import CoreLocation

/// Location permission lab screen: shows the current authorization status
/// and can request it. The label always reflects the real status so UI tests
/// can drive the screen through the system permission alert.
final class LocationPermissionViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private let statusLabel = UILabel()
    private let requestButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        locationManager.delegate = self

        statusLabel.textAlignment = .center
        statusLabel.accessibilityIdentifier = "location_status_label"
        statusLabel.text = LocationStatusFormatter.text(for: CLLocationManager.authorizationStatus())

        requestButton.setTitle("Solicitar permiso", for: .normal)
        requestButton.accessibilityIdentifier = "location_request_button"
        requestButton.addTarget(self, action: #selector(requestTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [statusLabel, requestButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func requestTapped() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationPermissionViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        statusLabel.text = LocationStatusFormatter.text(for: status)
    }
}

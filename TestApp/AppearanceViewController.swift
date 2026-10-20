import UIKit

/// Appearance lab screen: force light, dark or system appearance and preview
/// a Dynamic Type label. State is read back into labels so UI tests can
/// assert it deterministically. Dark mode only exists on iOS 13+.
final class AppearanceViewController: UIViewController {

    private let styleSegmented = UISegmentedControl(items: AppearanceScenario.all.map { $0.title })
    private let dynamicTypeLabel = UILabel()
    private let sizeCategoryLabel = UILabel()
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        styleSegmented.selectedSegmentIndex = AppearanceScenario.system.rawValue
        styleSegmented.accessibilityIdentifier = "appearance_style_segmented"
        styleSegmented.addTarget(self, action: #selector(styleChanged), for: .valueChanged)

        dynamicTypeLabel.text = "Texto con Dynamic Type"
        dynamicTypeLabel.textAlignment = .center
        dynamicTypeLabel.numberOfLines = 0
        dynamicTypeLabel.font = .preferredFont(forTextStyle: .body)
        dynamicTypeLabel.adjustsFontForContentSizeCategory = true
        dynamicTypeLabel.accessibilityIdentifier = "appearance_dynamic_label"

        sizeCategoryLabel.textAlignment = .center
        sizeCategoryLabel.font = .preferredFont(forTextStyle: .caption1)
        sizeCategoryLabel.accessibilityIdentifier = "appearance_size_category_label"

        statusLabel.textAlignment = .center
        statusLabel.accessibilityIdentifier = "appearance_status_label"

        if #available(iOS 13.0, *) {
            dynamicTypeLabel.textColor = .label
            sizeCategoryLabel.textColor = .secondaryLabel
            statusLabel.textColor = .label
        }

        let stack = UIStackView(arrangedSubviews: [styleSegmented, dynamicTypeLabel, sizeCategoryLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        updateLabels()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLabels()
    }

    @objc private func styleChanged() {
        guard let scenario = AppearanceScenario(rawValue: styleSegmented.selectedSegmentIndex) else {
            return
        }
        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = scenario.interfaceStyle
        }
        updateLabels()
    }

    private func updateLabels() {
        sizeCategoryLabel.text = "Tamaño: \(traitCollection.preferredContentSizeCategory.rawValue)"
        statusLabel.text = AppearanceStatusFormatter.text(for: traitCollection.userInterfaceStyle)
    }
}

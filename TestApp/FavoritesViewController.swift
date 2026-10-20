import UIKit

/// Favorites screen: every item can be marked as favorite and the state
/// persists across app relaunches (UserDefaults). Reset clears everything.
final class FavoritesViewController: UIViewController {

    private let tableView = UITableView()
    private let countLabel = UILabel()
    private let resetButton = UIButton(type: .system)
    private let store = FavoritesStore()

    private let items = [
        "Caso de prueba: login",
        "Caso de prueba: registro",
        "Caso de prueba: checkout",
        "Caso de prueba: recuperar contraseña"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        countLabel.textAlignment = .center
        countLabel.accessibilityIdentifier = "favorites_count_label"

        resetButton.setTitle("Reset favoritos", for: .normal)
        resetButton.accessibilityIdentifier = "favorites_reset_button"
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.accessibilityIdentifier = "favorites_table"

        let header = UIStackView(arrangedSubviews: [countLabel, resetButton])
        header.axis = .vertical
        header.spacing = 8
        header.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(header)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        updateCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateCount()
    }

    @objc private func resetTapped() {
        store.reset()
        tableView.reloadData()
        updateCount()
    }

    private func updateCount() {
        let count = store.all().count
        countLabel.text = count == 0 ? "Sin favoritos" : "\(count) favorito(s)"
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        let starred = store.isFavorite(item)
        cell.textLabel?.text = (starred ? "★ " : "☆ ") + item
        cell.accessibilityIdentifier = "fav_cell_\(indexPath.row)"
        cell.accessibilityValue = starred ? "favorito" : "no favorito"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.toggle(items[indexPath.row])
        tableView.reloadData()
        updateCount()
    }
}

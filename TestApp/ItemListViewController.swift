import UIKit

/// List screen with controlled scenarios (success / empty / error / slow)
/// so tests can reproduce each state deterministically.
final class ItemListViewController: UIViewController {

    private let scenarioControl = UISegmentedControl()
    private let tableView = UITableView()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    private var items: [String] = []
    private var scenario: ListScenario = .success

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        scenarioControl.removeAllSegments()
        for (index, title) in ItemStore.scenarioTitles.enumerated() {
            scenarioControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        scenarioControl.selectedSegmentIndex = scenario.rawValue
        scenarioControl.accessibilityIdentifier = "list_scenario_control"
        scenarioControl.addTarget(self, action: #selector(scenarioChanged), for: .valueChanged)

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.accessibilityIdentifier = "list_table"

        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .darkGray
        messageLabel.accessibilityIdentifier = "list_message_label"
        messageLabel.isHidden = true

        retryButton.setTitle("Reintentar", for: .normal)
        retryButton.accessibilityIdentifier = "list_retry_button"
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        retryButton.isHidden = true

        spinner.hidesWhenStopped = true
        spinner.accessibilityIdentifier = "list_loading_indicator"

        let stack = UIStackView(arrangedSubviews: [scenarioControl, spinner, messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        reload()
    }

    @objc private func scenarioChanged() {
        scenario = ListScenario(rawValue: scenarioControl.selectedSegmentIndex) ?? .success
        reload()
    }

    @objc private func retryTapped() {
        reload()
    }

    private func reload() {
        spinner.startAnimating()
        messageLabel.isHidden = true
        retryButton.isHidden = true
        items = []
        tableView.reloadData()

        let delay = (scenario == .slow) ? ItemStore.slowScenarioDelay : 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.spinner.stopAnimating()
            switch ItemStore.load(scenario: self.scenario) {
            case .items(let loaded):
                self.items = loaded
                if loaded.isEmpty {
                    self.messageLabel.text = "La lista está vacía"
                    self.messageLabel.isHidden = false
                }
            case .failure(let message):
                self.messageLabel.text = message
                self.messageLabel.isHidden = false
                self.retryButton.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
}

extension ItemListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

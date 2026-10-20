import UIKit

/// Registration form screen for the testing lab.
/// Built in code so every element carries an explicit accessibility identifier.
final class FormViewController: UIViewController {

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let successLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.accessibilityIdentifier = "form_email_textbox"

        passwordField.placeholder = "Contraseña"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.accessibilityIdentifier = "form_password_textbox"

        submitButton.setTitle("Registrarse", for: .normal)
        submitButton.accessibilityIdentifier = "form_submit_button"
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.accessibilityIdentifier = "form_error_label"

        successLabel.textColor = .green
        successLabel.numberOfLines = 0
        successLabel.accessibilityIdentifier = "form_success_label"

        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, submitButton, errorLabel, successLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func submitTapped() {
        let result = FormValidator.validate(email: emailField.text ?? "", password: passwordField.text ?? "")
        if let message = FormValidator.errorMessage(for: result) {
            errorLabel.text = message
            successLabel.text = ""
        } else {
            errorLabel.text = ""
            successLabel.text = "Registro correcto"
        }
    }
}

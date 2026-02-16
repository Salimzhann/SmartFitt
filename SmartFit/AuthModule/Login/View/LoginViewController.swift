//
//  LoginViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 08.02.2026.
//

import UIKit
import SnapKit
import Combine
import SafariServices

public protocol ILoginViewController: AnyObject {
    
    func showLoading()
    func hideLoading()
    func loginSuccess()
    func showError(_ message: String)
}


final class LoginViewController: UIViewController {
    
    private let logoIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_logo_ic"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.systemCyan.cgColor
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowPath = UIBezierPath(
            ovalIn: imageView.bounds
        ).cgPath
        imageView.layer.shadowRadius = 12
        return imageView
    }()
    private let baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.masksToBounds = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .label
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        return textField
    }()
    private let buttonLoader = UIActivityIndicatorView(style: .medium)
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        let text = "Don’t have an account? Sign up"

        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        let range = (text as NSString).range(of: "Sign up")

        attributed.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.blue.withAlphaComponent(0.5)
        ], range: range)

        label.attributedText = attributed
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsButtonTapped)))
        return label
    }()
    
    private var baseViewTopConstraint: Constraint?
    private let presenter: ILoginPresenter?
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: ILoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyboardObservers()
        
        configurePasswordField(passwordTextField)
        setupCloseKeyboardGesture()
        setupFormValidation()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoIcon)
        logoIcon.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(174)
        }
        
        view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            baseViewTopConstraint = make.top.equalTo(logoIcon.snp.bottom).offset(12).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        baseView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        baseView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        baseView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        baseView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        baseView.addSubview(signUpLabel)
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func setupFormValidation() {
        let emailValidPublisher = emailTextField.textPublisher
            .map { [weak self] in self?.isValidEmail($0) ?? false }

        let passwordValidPublisher = passwordTextField.textPublisher
            .map { $0.count >= 1 }

        Publishers
            .CombineLatest(
                emailValidPublisher,
                passwordValidPublisher
            )
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmailValid, isPasswordValid in
                let isFormValid = isEmailValid && isPasswordValid

                self?.confirmButton.isEnabled = isFormValid
                self?.confirmButton.alpha = isFormValid ? 1 : 0.5
            }
            .store(in: &cancellables)
    }
    
    private func setupCloseKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func configurePasswordField(_ textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword

        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .secondaryLabel
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)

        button.addAction(UIAction { [weak textField, weak button] _ in
            guard let textField = textField else { return }

            let isSecure = textField.isSecureTextEntry
            textField.isSecureTextEntry = !isSecure

            button?.setImage(UIImage(systemName: isSecure ? "eye" : "eye.slash"), for: .normal)

            // фикс курсора
            let current = textField.text
            textField.text = nil
            textField.text = current
        }, for: .touchUpInside)

        // ✅ контейнер дает правый padding
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 32 + 12, height: 32))
        button.center = CGPoint(x: container.bounds.midX - 6, y: container.bounds.midY)
        container.addSubview(button)

        textField.rightView = container
        textField.rightViewMode = .always
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    @objc private func termsButtonTapped() {
        let repository = SignUpRepository()
        let presenter = SignUpPresenter(repository: repository)
        let viewController = SignUpViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        let keyboardHeight = frame.height

        // поднимаем контейнер целиком
        baseViewTopConstraint?.update(offset: 12 - keyboardHeight / 2)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        baseViewTopConstraint?.update(offset: 12)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func confirmTapped() {
        presenter?.loginButtonTapped(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
}


extension LoginViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}


extension LoginViewController: ILoginViewController {
    
    func showLoading() {
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.7
        
        confirmButton.setTitle("", for: .normal)
        
        buttonLoader.color = .white
        buttonLoader.startAnimating()
        
        confirmButton.addSubview(buttonLoader)
        buttonLoader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func hideLoading() {
        confirmButton.isEnabled = true
        confirmButton.alpha = 1
        
        confirmButton.setTitle("Sign up", for: .normal)
        
        buttonLoader.stopAnimating()
        buttonLoader.removeFromSuperview()
    }
    
    func loginSuccess() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else {
            return
        }
        
        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        view.endEditing(true)
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

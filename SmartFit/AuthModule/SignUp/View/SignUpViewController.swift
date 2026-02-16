//
//  SignUpViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 07.02.2026.
//

import UIKit
import SnapKit
import Combine
import SafariServices

public protocol ISignUpViewController: AnyObject {
    
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func signUpSuccess(otpID: Int)
}


final class SignUpViewController: UIViewController {
    
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
        label.text = "Create account"
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
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm password"
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
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        let text = "You accepting our Terms and Conditions"

        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        let range = (text as NSString).range(of: "Terms and Conditions")

        attributed.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.blue.withAlphaComponent(0.5)
        ], range: range)

        label.attributedText = attributed
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsButtonTapped)))
        return label
    }()
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        let text = "Already have an account? Log in"

        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        let range = (text as NSString).range(of: "Log in")

        attributed.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.blue.withAlphaComponent(0.5)
        ], range: range)

        label.attributedText = attributed
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginTapped)))
        return label
    }()
    
    private var baseViewTopConstraint: Constraint?
    private let presenter: ISignUpPresenter?
    private var cancellables = Set<AnyCancellable>()
    
    init(presenter: ISignUpPresenter) {
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
        configurePasswordField(repeatPasswordTextField)
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
        
        baseView.addSubview(repeatPasswordTextField)
        repeatPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        baseView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        baseView.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        baseView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(termsLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func setupFormValidation() {
        let emailValidPublisher = emailTextField.textPublisher
            .map { [weak self] in self?.isValidEmail($0) ?? false }

        let passwordValidPublisher = passwordTextField.textPublisher
            .map { $0.count >= 6 }

        let passwordsMatchPublisher = Publishers
            .CombineLatest(
                passwordTextField.textPublisher,
                repeatPasswordTextField.textPublisher
            )
            .map { $0 == $1 && !$0.isEmpty }

        Publishers
            .CombineLatest3(
                emailValidPublisher,
                passwordValidPublisher,
                passwordsMatchPublisher
            )
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmailValid, isPasswordValid, passwordsMatch in
                let isFormValid = isEmailValid && isPasswordValid && passwordsMatch

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
        guard let url = URL(
            string: "https://terms-and-conditions-mobile.vercel.app/"
        ) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
    
    @objc private func loginTapped() {
        let repository = LoginRepository()
        let presenter = LoginPresenter(repository: repository)
        let viewController: (ILoginViewController & UIViewController) = LoginViewController(presenter: presenter)
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
        presenter?.confirmButtonTapped(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}


extension SignUpViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}


extension SignUpViewController: ISignUpViewController {
    
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
    
    func signUpSuccess(otpID: Int) {
        let repository = SignUpRepository()
        let presenter = OTPPresenter(otpID: otpID, repository: repository)
        let vc = OtpViewController(presenter: presenter, email: emailTextField.text ?? "")
        presenter.view = vc
        navigationController?.pushViewController(vc, animated: true)
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

//
//  OnboardingViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.02.2026.
//

import UIKit
import SnapKit


final class OnboardingViewController: UIViewController {
    
    private let logoIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_logo_ic"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.systemCyan.cgColor
        imageView.layer.shadowOpacity = 0.15
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowPath = UIBezierPath(
            ovalIn: imageView.bounds
        ).cgPath
        imageView.layer.shadowRadius = 20
        return imageView
    }()
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to SmartFit"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoIcon)
        logoIcon.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(170)
        }
        
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoIcon.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func signUpTapped() {
        let repository = SignUpRepository()
        let presenter = SignUpPresenter(repository: repository)
        let viewController = SignUpViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func loginTapped() {
        let repository = LoginRepository()
        let presenter = LoginPresenter(repository: repository)
        let viewController = LoginViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

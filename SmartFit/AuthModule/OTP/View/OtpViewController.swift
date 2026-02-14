//
//  OtpViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.02.2026.
//

import UIKit
import SnapKit


final class OtpViewController: UIViewController {
    
    private let enterOtpLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter OTP"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let sendOtpLabel: UILabel = {
        let label = UILabel()
        label.text = "We’ve sent an OTP code to your email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .blue.withAlphaComponent(0.7)
        return label
    }()
    private lazy var otpView: OTPView = {
        let view = OTPView()
        view.onComplete = { [weak self] _ in
            self?.verifyButton.isEnabled = true
            self?.verifyButton.alpha = 1
        }
        return view
    }()
    private lazy var verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        return button
    }()
    private let resendLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private var timer: Timer?
    private var remainingSeconds = 59
    
    init(email: String) {
        emailLabel.text = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startResendTimer()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(enterOtpLabel)
        enterOtpLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(sendOtpLabel)
        sendOtpLabel.snp.makeConstraints { make in
            make.top.equalTo(enterOtpLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(sendOtpLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(otpView)
        otpView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        view.addSubview(verifyButton)
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(otpView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        view.addSubview(resendLabel)
        resendLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    private func startResendTimer() {
        remainingSeconds = 59
        updateTimerText()

        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func timerTick() {
        remainingSeconds -= 1
        updateTimerText()

        if remainingSeconds <= 0 {
            timer?.invalidate()
            showResend()
        }
    }
    
    private func updateTimerText() {
        let text = "We will resend the code in \(remainingSeconds) s"

        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        let range = (text as NSString).range(of: "\(remainingSeconds) s")
        attributed.addAttribute(
            .foregroundColor,
            value: UIColor.systemBlue,
            range: range
        )

        resendLabel.attributedText = attributed
    }
    
    private func showResend() {
        let text = "Resend code"

        resendLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]
        )

        resendLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(resendTapped))
        )
    }
    
    @objc private func resendTapped() {
        resendLabel.gestureRecognizers?.removeAll()

        // 🔥 тут твой запрос на бэк
//        presenter.resendCode()

        startResendTimer()
    }
    
    @objc private func verifyTapped() {
        
    }
}

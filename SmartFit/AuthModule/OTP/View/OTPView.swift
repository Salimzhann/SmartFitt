//
//  OTPView.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.02.2026.
//

import UIKit


final class OTPView: UIView {

    private let digitsCount = 6
    private var code: String = "" {
        didSet { updateUI() }
    }

    private lazy var hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.isHidden = true
        tf.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return tf
    }()

    private var digitLabels: [UILabel] = []
    var onComplete: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(hiddenTextField)

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12

        for _ in 0..<digitsCount {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            label.layer.cornerRadius = 12
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.systemGray4.cgColor
            label.clipsToBounds = true
            label.text = "-"

            digitLabels.append(label)
            stack.addArrangedSubview(label)
        }

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeActive)))
    }
    
    @objc private func becomeActive() {
        hiddenTextField.becomeFirstResponder()
    }
    
    @objc private func textChanged() {
        guard let text = hiddenTextField.text else { return }
        code = String(text.prefix(digitsCount))
        hiddenTextField.text = code
        
        if code.count == digitsCount {
            hiddenTextField.resignFirstResponder() // 👈 закрываем клавиатуру
            onComplete?(code)                      // 👈 отдаём код
        }
    }
    
    private func updateUI() {
        for i in 0..<digitLabels.count {
            if i < code.count {
                let index = code.index(code.startIndex, offsetBy: i)
                digitLabels[i].text = String(code[index])
                digitLabels[i].layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                digitLabels[i].text = "-"
                digitLabels[i].layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
    }
    
    func getCode() -> String {
        return code
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

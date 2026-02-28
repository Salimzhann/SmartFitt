//
//  ChatInputView.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 28.02.2026.
//

import UIKit
import SnapKit


final class ChatInputView: UIView {

    let textField = UITextField()
    let sendButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16

        textField.placeholder = "Message"
        textField.borderStyle = .none

        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)

        addSubview(textField)
        addSubview(sendButton)

        textField.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(12)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
            $0.height.equalTo(24)
        }

        sendButton.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview().inset(12)
        }
    }
}

//
//  ChatMessageCell.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 28.02.2026.
//

import UIKit
import SnapKit


final class ChatMessageCell: UITableViewCell {

    static let reuseId = "ChatMessageCell"

    private let bubbleView = UIView()
    private let messageLabel = UILabel()

    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15)

        bubbleView.layer.cornerRadius = 16
        bubbleView.addSubview(messageLabel)

        contentView.addSubview(bubbleView)

        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        bubbleView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.75)

            leadingConstraint = $0.leading.equalToSuperview().inset(16).constraint
            trailingConstraint = $0.trailing.equalToSuperview().inset(16).constraint
        }
    }

    func configure(with model: ChatMessageViewModel) {
        messageLabel.text = model.text

        if model.isIncoming {
            bubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .label
            leadingConstraint?.activate()
            trailingConstraint?.deactivate()
        } else {
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            trailingConstraint?.activate()
            leadingConstraint?.deactivate()
        }
    }
}

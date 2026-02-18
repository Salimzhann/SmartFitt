//
//  HabitChallengeCell.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.02.2026.
//

import UIKit
import SnapKit


final class HabitChallengeCell: UICollectionViewCell {

    static let reuseId = "HabitChallengeCell"
    
    private let containerView = UIView()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    var onActionTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    private func setupUI() {
        containerView.layer.cornerRadius = 20
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
        }

        containerView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(46)
            make.height.equalTo(44)
        }
    }

    func configure(with model: HabitChallengeViewModel) {
        titleLabel.text = model.title
        actionButton.setTitle(model.buttonTitle, for: .normal)
        actionButton.backgroundColor = model.buttonBackgroundColor
        containerView.backgroundColor = model.backgroundColor
        imageView.image = model.image
    }
    
    @objc private func buttonTapped() {
        onActionTap?()
    }
}

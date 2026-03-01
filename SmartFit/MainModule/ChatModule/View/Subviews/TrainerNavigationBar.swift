//
//  TrainerNavigationBar.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 01.03.2026.
//

import UIKit
import SnapKit


final class TrainerNavigationBar: UIView {
    
    private let trainerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .trainerAvatar
        imageView.clipsToBounds = true
        return imageView
    }()
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your AI Coach"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let onlineStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Online"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        return label
    }()
    private lazy var deleteHistoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear history", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    
    var onDeleteHistory: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        addSubview(trainerImageView)
        trainerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
        addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.equalTo(trainerImageView.snp.trailing).offset(12)
        }
        
        addSubview(onlineStatusLabel)
        onlineStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom)
            make.leading.equalTo(trainerImageView.snp.trailing).offset(12)
        }
        
        addSubview(deleteHistoryButton)
        deleteHistoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(trainerImageView)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func deleteTapped() {
        onDeleteHistory?()
    }
}

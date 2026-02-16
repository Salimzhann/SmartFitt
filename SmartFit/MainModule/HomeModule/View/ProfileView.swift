//
//  ProfileView.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit


final class ProfileView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        button.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        button.tintColor = .gray
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    var onLogOut: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    func configure(image: UIImage, username: String, email: String) {
        imageView.image = image
        usernameLabel.text = username
        emailLabel.text = email
    }
    
    private func setupViews() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(16)
            make.size.equalTo(56)
        }
        
        self.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(imageView)
            make.size.equalTo(32)
        }
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.trailing.equalTo(logOutButton.snp.leading).offset(-12)
        }
    }
    
    @objc private func logOutTapped() {
        onLogOut?()
        print("oisfnsoen")
    }
}

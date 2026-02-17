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
    private let avatarSkeleton = UIView()
    private let nameSkeleton = UIView()
    private let emailSkeleton = UIView()

    private var skeletonViews: [UIView] {
        [avatarSkeleton, nameSkeleton, emailSkeleton]
    }
    
    private var shimmerKey = "shimmer"
    var onLogOut: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupSkeleton()
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
        
        addSubview(avatarSkeleton)
        avatarSkeleton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }

        addSubview(nameSkeleton)
        nameSkeleton.snp.makeConstraints { make in
            make.leading.equalTo(avatarSkeleton.snp.trailing).offset(20)
            make.top.equalTo(avatarSkeleton).offset(8)
            make.width.equalTo(120)
            make.height.equalTo(14)
        }

        addSubview(emailSkeleton)
        emailSkeleton.snp.makeConstraints { make in
            make.leading.equalTo(nameSkeleton)
            make.top.equalTo(nameSkeleton.snp.bottom).offset(8)
            make.width.equalTo(160)
            make.height.equalTo(14)
        }
    }
    
    private func setupSkeleton() {
        avatarSkeleton.backgroundColor = UIColor.systemGray5
        avatarSkeleton.layer.cornerRadius = 28
        avatarSkeleton.clipsToBounds = true

        nameSkeleton.backgroundColor = UIColor.systemGray5
        nameSkeleton.layer.cornerRadius = 6

        emailSkeleton.backgroundColor = UIColor.systemGray5
        emailSkeleton.layer.cornerRadius = 6
    }
    
    @objc private func logOutTapped() {
        onLogOut?()
    }
    
    func showSkeleton() {
        imageView.isHidden = true
        stackView.isHidden = true
        logOutButton.isHidden = true

        skeletonViews.forEach { $0.isHidden = false }
        startShimmer()
    }

    func hideSkeleton() {
        imageView.isHidden = false
        stackView.isHidden = false
        logOutButton.isHidden = false

        skeletonViews.forEach { $0.isHidden = true }
        stopShimmer()
    }
    
    private func startShimmer() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.6
        animation.toValue = 1.0
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity

        skeletonViews.forEach {
            $0.layer.add(animation, forKey: shimmerKey)
        }
    }

    private func stopShimmer() {
        skeletonViews.forEach {
            $0.layer.removeAnimation(forKey: shimmerKey)
        }
    }
}

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

    // MARK: - Inactive state views
    private let inactiveContent = UIView()
    private let inactiveTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let inactiveImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Active state views
    private let activeContent = UIView()
    private let activeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let informerImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .gray
        return iv
    }()
    private let activeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Weekly goal"
        return label
    }()
    private let progressBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.layer.cornerRadius = 12
        pv.clipsToBounds = true
        pv.trackTintColor = .softGreenBackground
        pv.progressTintColor = .softGreen
        return pv
    }()
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .label
        return label
    }()
    private lazy var markTodayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Mark today", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(markTodayTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Callbacks
    var onStartTap: (() -> Void)?
    var onMarkTodayTap: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { nil }

    // MARK: - Setup
    private func setupUI() {
        containerView.layer.cornerRadius = 20
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }

        setupInactiveLayout()
        setupActiveLayout()
    }

    private func setupInactiveLayout() {
        
        containerView.addSubview(inactiveContent)
        inactiveContent.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        inactiveContent.addSubview(inactiveTitleLabel)
        inactiveTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        inactiveContent.addSubview(inactiveImageView)
        inactiveImageView.snp.makeConstraints { make in
            make.top.equalTo(inactiveTitleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
        }

        inactiveContent.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(46)
            make.height.equalTo(44)
        }
    }

    private func setupActiveLayout() {
        containerView.addSubview(activeContent)
        activeContent.snp.makeConstraints { $0.edges.equalToSuperview() }

        activeContent.addSubview(activeImageView)
        activeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(100)
        }

        activeContent.addSubview(activeTitleLabel)
        activeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(activeImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        activeContent.addSubview(informerImageView)
        informerImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }

        activeContent.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(activeTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(activeImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }

        activeContent.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(10)
            make.leading.equalTo(activeImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }

        activeContent.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(progressBar)
            make.trailing.equalTo(progressBar.snp.trailing).offset(-8)
        }
        
        activeContent.addSubview(markTodayButton)
        markTodayButton.snp.makeConstraints { make in
            make.top.equalTo(activeImageView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(140)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configure
    func configure(with model: HabitChallengeViewModel) {
        containerView.backgroundColor = model.backgroundColor

        if model.isActive {
            inactiveContent.isHidden = true
            activeContent.isHidden = false

            activeImageView.image = model.image
            activeTitleLabel.text = model.activatedTitle

            let progress = Float(model.completedDays) / Float(model.totalDays)
            progressBar.setProgress(progress, animated: false)
            progressLabel.text = "\(model.completedDays) / \(model.totalDays) days"

            // Если уже отметился сегодня — кнопку неактивной делаем
            markTodayButton.isEnabled = !model.isMarkedToday
            markTodayButton.alpha = model.isMarkedToday ? 0.5 : 1.0
            markTodayButton.backgroundColor = model.buttonBackgroundColor
        } else {
            inactiveContent.isHidden = false
            activeContent.isHidden = true

            inactiveImageView.image = model.image
            inactiveTitleLabel.text = model.title
            startButton.setTitle(model.buttonTitle, for: .normal)
            startButton.backgroundColor = model.buttonBackgroundColor
        }
    }

    // MARK: - Actions
    @objc private func startTapped() {
        onStartTap?()
    }

    @objc private func markTodayTapped() {
        onMarkTodayTap?()
    }
}

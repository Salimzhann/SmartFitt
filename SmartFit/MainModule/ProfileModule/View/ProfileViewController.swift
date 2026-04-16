//
//  ProfileViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 15.04.2026.
//

import UIKit
import SnapKit

protocol IProfileView: AnyObject {
    
    var presenter: IProfilePresenter? { get set }
}


class ProfileViewController: UIViewController, IProfileView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .defaultAvatarIc
        imageView.clipsToBounds = true
        return imageView
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "manassalimzhan04@gmail.com"
        label.textAlignment = .center
        return label
    }()
    private let forkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "fork.knife")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let weeklyCaloriesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Calories Eaten"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let weeklyCaloriesResultLabel: UILabel = {
        let label = UILabel()
        label.text = "9234/10000 cal"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private lazy var weeklyCaloriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .softBlue.withAlphaComponent(0.4)
        stackView.layer.cornerRadius = 16
        stackView.addArrangedSubview(weeklyCaloriesTitleLabel)
        stackView.addArrangedSubview(weeklyCaloriesResultLabel)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        return stackView
    }()
    private let macrosStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private let bodyMetricsLabel: UILabel = {
        let label = UILabel()
        label.text = "Body Metrics"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    private let measureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lines.measurement.horizontal")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let bodyMetricsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .softBlue.withAlphaComponent(0.4)
        return view
    }()
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private lazy var heightValueView: UIView = {
        let label = UILabel()
        label.text = "180 cm"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        let contentView = wrapperView(contentView: label, insets: .init(top: 10, left: 10, bottom: 10, right: 10))
        return contentView
    }()
    private lazy var weightValueView: UIView = {
        let label = UILabel()
        label.text = "80 kg"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        let contentView = wrapperView(contentView: label, insets: .init(top: 10, left: 10, bottom: 10, right: 10))
        return contentView
    }()
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        
        button.setImage(image, for: .normal)
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .systemRed
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var presenter: IProfilePresenter?
    
    override func viewDidLoad() {
        presenter?.viewDidLoad()
        setupViews()
        setupMacros()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(weeklyCaloriesStackView)
        weeklyCaloriesStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        weeklyCaloriesStackView.addSubview(forkImage)
        forkImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(32)
        }
        
        view.addSubview(macrosStackView)
        macrosStackView.snp.makeConstraints { make in
            make.top.equalTo(weeklyCaloriesStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(bodyMetricsView)
        bodyMetricsView.snp.makeConstraints { make in
            make.top.equalTo(macrosStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bodyMetricsView.addSubview(measureImage)
        measureImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        bodyMetricsView.addSubview(bodyMetricsLabel)
        bodyMetricsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(measureImage.snp.trailing).offset(4)
        }
        
        view.addSubview(heightLabel)
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyMetricsView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(heightValueView)
        heightValueView.snp.makeConstraints { make in
            make.centerY.equalTo(heightLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(weightLabel)
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(weightValueView)
        weightValueView.snp.makeConstraints { make in
            make.centerY.equalTo(weightLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
    
    private func setupMacros() {
        let protein = MacroView(
            title: "Protein",
            value: "420 g / 560 g",
            progress: 420.0 / 560.0,
            color: .systemGreen
        )
        
        let carbs = MacroView(
            title: "Carbs",
            value: "980 g / 1200 g",
            progress: 980.0 / 1200.0,
            color: .systemBlue
        )
        
        let fats = MacroView(
            title: "Fats",
            value: "500 g / 420 g",
            progress: min(500.0 / 420.0, 1.0),
            color: .systemOrange
        )
        
        macrosStackView.addArrangedSubview(protein)
        macrosStackView.addArrangedSubview(carbs)
        macrosStackView.addArrangedSubview(fats)
    }
    
    private func wrapperView(contentView: UIView, insets: UIEdgeInsets) -> UIView {
        let view  = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .softBlue.withAlphaComponent(0.4)
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
        return view
    }
    
    @objc private func logoutButtonTapped() {
        presenter?.logoutTapped()
    }
}

//
//  InformerBottomSheetView.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 26.02.2026.
//

import UIKit
import SnapKit
import PanModal


final class InformerBottomSheetView: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "About this Habit"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 24
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray3.withAlphaComponent(0.3).cgColor
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(buildDescriptionView(title: "Improved Cognitive Function", subtitle: "Better focus, memory, and decision making throughout the day."))
        stackView.addArrangedSubview(buildDescriptionView(title: "Better Muscle Recovery", subtitle: "Deep sleep allows your tissues to repair and grow after exercise."))
        stackView.addArrangedSubview(buildDescriptionView(title: "Mood Stabilization", subtitle: "Reduces irritability and helps manage stress levels effectively."))
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    
    private func buildDescriptionView(title: String, subtitle: String) -> UIView {
        let view = UIView()
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .light)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = subtitle
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        
        view.addSubview(textStackView)
        textStackView.snapshotView(afterScreenUpdates: false)?.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView(image: UIImage(systemName: "smallcircle.filled.circle"))
        image.tintColor = .label
        
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        view.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        return view
    }
}


extension InformerBottomSheetView: PanModalPresentable {
    
    var showDragIndicator: Bool { false }
    var longFormHeight: PanModalHeight { .intrinsicHeight }
    var cornerRadius: CGFloat { 24 }
    var panScrollable: UIScrollView? { nil }
}

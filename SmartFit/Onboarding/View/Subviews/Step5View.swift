//
//  Step5View.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import UIKit
import SnapKit


final class Step5View: UIView {
    
    enum ActivityLevel: String {
        case loseWeight = "Lose Weight"
        case buildMuscle = "Build Muscle"
        case stayFit = "Stay Fit"
        case imroveFlexibility = "Imrove Flexibility"
    }
    
    var selectedActivity: ActivityLevel = .loseWeight
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Physical activity level"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let loseWeightView = ActivityOptionView()
    private let buildMuscleView = ActivityOptionView()
    private let stayFitView = ActivityOptionView()
    private let imroveFlexibilityView = ActivityOptionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setup() {
        backgroundColor = .clear
        
        loseWeightView.configure(icon: UIImage(systemName: "flame.fill") ?? .appLogoIc, title: "Lose Weight")
        buildMuscleView.configure(icon: UIImage(systemName: "dumbbell") ?? .appLogoIc, title: "Build Muscle")
        stayFitView.configure(icon: UIImage(systemName: "heart.fill") ?? .appLogoIc, title: "Stay Fit")
        imroveFlexibilityView.configure(icon: UIImage(systemName: "figure.yoga") ?? .appLogoIc, title: "Imrove Flexibility")
        
        let stack = UIStackView(arrangedSubviews: [
            loseWeightView,
            buildMuscleView,
            stayFitView,
            imroveFlexibilityView
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        addSubview(titleLabel)
        addSubview(stack)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        stack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        [loseWeightView, buildMuscleView, stayFitView, imroveFlexibilityView].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(80) }
        }
        
        setupActions()
        updateSelection()
    }
    
    private func setupActions() {
        loseWeightView.onTap = { [weak self] in
            self?.select(.loseWeight)
        }
        
        buildMuscleView.onTap = { [weak self] in
            self?.select(.buildMuscle)
        }
        
        stayFitView.onTap = { [weak self] in
            self?.select(.stayFit)
        }
        
        imroveFlexibilityView.onTap = { [weak self] in
            self?.select(.imroveFlexibility)
        }
    }
    
    private func select(_ level: ActivityLevel) {
        selectedActivity = level
        updateSelection()
    }
    
    private func updateSelection() {
        loseWeightView.setSelected(selectedActivity == .loseWeight)
        buildMuscleView.setSelected(selectedActivity == .buildMuscle)
        stayFitView.setSelected(selectedActivity == .stayFit)
        imroveFlexibilityView.setSelected(selectedActivity == .imroveFlexibility)
    }
}


extension Step5View: OnboardingStep {
    func getData() -> Any {
        Step5Data(goal: selectedActivity.rawValue)
    }
}

struct Step5Data {
    let goal: String
}

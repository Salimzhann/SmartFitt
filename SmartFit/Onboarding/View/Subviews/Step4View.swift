//
//  Step4View.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import UIKit
import SnapKit


final class Step4View: UIView {
    
    enum ActivityLevel: String {
        
        case beginner = "BEGINNER"
        case intermediate = "INTERMEDIATE"
        case advanced = "ADVANCED"
    }
    
    var selectedActivity: ActivityLevel = .beginner
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Physical activity level"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let beginnerView = ActivityOptionView()
    private let intermediateView = ActivityOptionView()
    private let advancedView = ActivityOptionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setup() {
        backgroundColor = .clear
        
        beginnerView.configure(icon: .beginnerChartIc, title: "Beginner")
        intermediateView.configure(icon: .intermediateChartIc, title: "Intermediate")
        advancedView.configure(icon: UIImage(systemName: "chart.bar.fill") ?? .advancedChartIc, title: "Advanced")
        
        let stack = UIStackView(arrangedSubviews: [
            beginnerView,
            intermediateView,
            advancedView
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
        
        [beginnerView, intermediateView, advancedView].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(80) }
        }
        
        setupActions()
        updateSelection()
    }
    
    private func setupActions() {
        beginnerView.onTap = { [weak self] in
            self?.select(.beginner)
        }
        
        intermediateView.onTap = { [weak self] in
            self?.select(.intermediate)
        }
        
        advancedView.onTap = { [weak self] in
            self?.select(.advanced)
        }
    }
    
    private func select(_ level: ActivityLevel) {
        selectedActivity = level
        updateSelection()
    }
    
    private func updateSelection() {
        beginnerView.setSelected(selectedActivity == .beginner)
        intermediateView.setSelected(selectedActivity == .intermediate)
        advancedView.setSelected(selectedActivity == .advanced)
    }
}


extension Step4View: OnboardingStep {
    func getData() -> Any {
        Step4Data(activity: selectedActivity.rawValue)
    }
}

struct Step4Data {
    let activity: String
}

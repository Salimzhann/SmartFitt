//
//  HelperOnboardingViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 17.03.2026.
//

import UIKit
import SnapKit

protocol IHelperOnboardingView: AnyObject {
    
    var presenter: IHelperOnboardingPresenter? { get set }
    
    func onboardingSuccess()
    func showError(_ message: String)
}

protocol OnboardingStep {
    
    func getData() -> Any
}


final class HelperOnboardingViewController: UIViewController, IHelperOnboardingView {
    
    private var currentStep = 0
    
    private let steps: [UIView] = [
        Step1View(),
        Step2View(),
        Step3View(),
        Step4View(),
        Step5View()
    ]
    
    private lazy var progressView = StepIndicatorView(steps: steps.count)
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        return button
    }()
    
    var presenter: IHelperOnboardingPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showStep(0)
        presenter?.viewDidload()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(progressView)
        view.addSubview(nextButton)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(8)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    // MARK: - Step handling
    
    private func showStep(_ index: Int) {
        
        // удаляем предыдущий step
        view.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }
        
        let stepView = steps[index]
        stepView.tag = 999
        
        view.addSubview(stepView)
        stepView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stepView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            stepView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stepView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20)
        ])
        
        progressView.update(current: index)
    }
    
    @objc private func nextTapped() {
        if currentStep < steps.count - 1 {
            currentStep += 1
            showStep(currentStep)
        } else {
            finishOnboarding()
        }
    }
    
    private func finishOnboarding() {
        let data = collectData()
        presenter?.submit(data: data)
    }
    
    private func collectData() -> OnboardingData {
        var result = OnboardingData()
        
        for step in steps {
            guard let step = step as? OnboardingStep else { continue }
            
            let data = step.getData()
            
            switch data {
            case let d as Step1Data:
                result.age = d.age
                result.gender = Gender(rawValue: d.gender)

            case let d as Step2Data:
                result.height = d.height
                
            case let d as Step3Data:
                result.weight = d.weight
                
            case let d as Step4Data:
                result.activity = ActivityLevel(rawValue: d.activity)
                
            case let d as Step5Data:
                result.goal = Goal(rawValue: d.goal)
                
            default:
                break
            }
        }
        
        return result
    }
    
    func onboardingSuccess() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


final class StepIndicatorView: UIStackView {
    
    private var totalSteps: Int = 0
    private var indicators: [UIView] = []
    
    init(steps: Int) {
        super.init(frame: .zero)
        self.totalSteps = steps
        setup()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        axis = .horizontal
        spacing = 6
        distribution = .fillEqually
        
        for _ in 0..<totalSteps {
            let view = UIView()
            view.backgroundColor = UIColor.systemGray4
            view.layer.cornerRadius = 3
            indicators.append(view)
            addArrangedSubview(view)
        }
    }
    
    func update(current: Int) {
        for (index, view) in indicators.enumerated() {
            if index <= current {
                view.backgroundColor = .systemBlue
            } else {
                view.backgroundColor = UIColor.systemGray4
            }
        }
    }
}

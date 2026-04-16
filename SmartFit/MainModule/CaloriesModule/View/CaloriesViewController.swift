//
//  CaloriesViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit

protocol ICaloriesView: AnyObject {

    var presenter: ICaloriesPresenter? { get set }

    func showCalories(response: CaloriesResponse, isNextEnabled: Bool, isPrevEnabled: Bool)
    func didReceiveNutrition(result: NutritionResponse)
    func showError(message: String)
}


final class CaloriesViewController: UIViewController {

    private let kcalContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.backgroundColor = .softBlue.withAlphaComponent(0.3)
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(nextTap), for: .touchUpInside)
        return button
    }()
    private lazy var prevButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(prevTap), for: .touchUpInside)
        return button
    }()
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let myMealsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "My meals"
        return label
    }()
    private let mealsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    private lazy var scanButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "camera.fill")
        
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 28
        button.setTitle(" Scan your food", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(scanTap), for: .touchUpInside)
        
        return button
    }()

    var presenter: ICaloriesPresenter?
    private let circleRadius: CGFloat = 85
    private var circleInitialized = false
    private weak var currentCameraVC: FoodCameraViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        guard !circleInitialized else { return }
        circleInitialized = true

        setupCircle()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(kcalContentView)
        kcalContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }

        kcalContentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        kcalContentView.addSubview(kcalLabel)
        kcalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        kcalContentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        kcalContentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }

        kcalContentView.addSubview(prevButton)
        prevButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(myMealsLabel)
        myMealsLabel.snp.makeConstraints { make in
            make.top.equalTo(kcalContentView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(mealsStackView)
        mealsStackView.snp.makeConstraints { make in
            make.top.equalTo(myMealsLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(scanButton)
        scanButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
    private func setupCircle() {
        
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        
        let center = CGPoint(
            x: kcalContentView.bounds.midX,
            y: kcalContentView.bounds.midY
        )
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: circleRadius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )
        
        trackLayer.path = path.cgPath
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.6).cgColor
        trackLayer.lineWidth = 8
        trackLayer.fillColor = UIColor.clear.cgColor
        
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = 8
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        
        kcalContentView.layer.addSublayer(trackLayer)
        kcalContentView.layer.addSublayer(progressLayer)
    }
    
    private func updateCircle(kcal: Double) {
        
        guard circleInitialized else { return }
        
        let maxKcal: CGFloat = 2000
        let progress = min(CGFloat(kcal) / maxKcal, 1)
        
        progressLayer.strokeEnd = progress
    }
    
    private func setupNutritionLabels(text: String) -> UILabel {
        let label: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .deepTeal
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()
        
        return label
    }
    
    private func formatDate(_ string: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM, yyyy"
        
        guard let date = inputFormatter.date(from: string) else {
            return string
        }
        
        return outputFormatter.string(from: date)
    }

    @objc private func nextTap() {
        presenter?.didTapNextDay()
    }

    @objc private func prevTap() {
        presenter?.didTapPreviousDay()
    }
    
    @objc private func scanTap() {
        let vc = FoodCameraViewController()
        vc.delegate = self
        currentCameraVC = vc
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


extension CaloriesViewController: ICaloriesView {

    func showCalories(response: CaloriesResponse, isNextEnabled: Bool, isPrevEnabled: Bool) {
        updateCircle(kcal: response.weight.kcal)

        kcalLabel.text = "\(response.weight.kcal) \n Kcal"
        dateLabel.text = formatDate(response.nutritionDate)
        
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        mealsStackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        response.meals.forEach { meal in
            let label = UILabel()
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.numberOfLines = 0
            label.text = meal.name + " - \(meal.kcal) Kcal"
            mealsStackView.addArrangedSubview(label)
        }
        
        stackView.addArrangedSubview(setupNutritionLabels(text: "Protein \n \(response.weight.protein) g"))
        stackView.addArrangedSubview(setupNutritionLabels(text: "Fat \n \(response.weight.fat) g"))
        stackView.addArrangedSubview(setupNutritionLabels(text: "Carbs \n \(response.weight.carbs) g"))

        nextButton.isEnabled = isNextEnabled
        prevButton.isEnabled = isPrevEnabled
    }
    
    func didReceiveNutrition(result: NutritionResponse) {
        currentCameraVC?.showResult(result)
    }
    
    func showError(message: String) {
        currentCameraVC?.dismissResult(message: message)
    }
}


extension CaloriesViewController: FoodCameraDelegate {
    
    func didCaptureFood(image: UIImage) {
        presenter?.uploadFood(image: image)
    }
}

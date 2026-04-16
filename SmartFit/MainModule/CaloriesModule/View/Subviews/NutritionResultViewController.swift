//
//  NutritionResultViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import UIKit
import SnapKit
import PanModal

protocol NutritionResultViewControllerDelegate: AnyObject {
    
    func presenterViewClosed()
}


final class NutritionResultViewController: UIViewController {
    
    private let contentView = UIView()
    private let loader = UIActivityIndicatorView(style: .large)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Analyzing food..."
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let totalCalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total calories"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    private let macrosLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stackView.axis = .vertical
        stackView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 16
        stackView.spacing = 4
        stackView.isHidden = true
        return stackView
    }()
    
    weak var delegate: NutritionResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.presenterViewClosed()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 24
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(loader)
        loader.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(totalCalLabel)
        totalCalLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }

        contentView.addSubview(kcalLabel)
        kcalLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalCalLabel)
            $0.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(totalCalLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24) // 👈 важно для intrinsic
        }

        loader.startAnimating()
    }

    func showResult(_ result: NutritionResponse) {
        loader.stopAnimating()
        loader.isHidden = true

        titleLabel.text = result.mealName
        kcalLabel.text = "\(format(result.kcal)) kcal"
        
        infoStackView.arrangedSubviews.forEach {
            infoStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        infoStackView.addArrangedSubview(getText(text: "Protein: \(format(result.protein)) g"))
        infoStackView.addArrangedSubview(getText(text: "Fat: \(format(result.fat)) g"))
        infoStackView.addArrangedSubview(getText(text: "Carbs: \(format(result.carbs)) g"))
        infoStackView.addArrangedSubview(getText(text: "Serving: \(format(result.servingAmount)) \(result.servingUnit)"))

        kcalLabel.isHidden = false
        infoStackView.isHidden = false
        totalCalLabel.isHidden = false
        
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .shortForm)
    }
    
    private func getText(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        return label
    }
    
    private func format(_ value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(value))"
            : "\(value)"
    }
    
    private func calculateHeight() -> CGFloat {
        view.layoutIfNeeded()
        return contentView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        ).height
    }
}


extension NutritionResultViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { nil }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(calculateHeight())
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(calculateHeight())
    }

    var cornerRadius: CGFloat { 24 }

    var showDragIndicator: Bool { true }
}

//
//  WaterViewModel.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 17.02.2026.
//

import UIKit
import SnapKit


final class WaterCounterView: UIView {
    
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        return view
    }()
    private let contentView = UIView()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "= 250 ml"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private let drunkTodayLabel: UILabel = {
        let label = UILabel()
        label.text = "Drunk today"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let totalMlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle("  Add Glass", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    private lazy var reduceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(reduceTapped), for: .touchUpInside)
        return button
    }()
    private let blocksStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let glassImageView: UIImageView = {
        let image = UIImageView(image: .glassIc)
        image.contentMode = .scaleAspectFit
        return image
    }()
    private var blocks: [WaterBlockView] = []
    private let viewModel = WaterViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupContent()
        setupBlocks()
        updateUI()
    }

    required init?(coder: NSCoder) { nil }


    private func setupShadow() {
        
        addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupContent() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
        
        shadowView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.addSubview(glassImageView)
        glassImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 40, height: 45))
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints {
            $0.leading.equalTo(glassImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(glassImageView)
        }
        
        contentView.addSubview(drunkTodayLabel)
        drunkTodayLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(totalMlLabel)
        totalMlLabel.snp.makeConstraints { make in
            make.top.equalTo(drunkTodayLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(blocksStack)
        blocksStack.snp.makeConstraints {
            $0.top.equalTo(glassImageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        contentView.addSubview(reduceButton)
        reduceButton.snp.makeConstraints { make in
            make.top.equalTo(blocksStack.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(18)
            make.size.equalTo(CGSize(width: 46, height: 36))
        }
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(reduceButton)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(reduceButton.snp.trailing).offset(12)
            $0.height.equalTo(44)
        }
    }

    private func setupBlocks() {
        for _ in 0..<8 {
            let block = WaterBlockView()
            blocks.append(block)
            blocksStack.addArrangedSubview(block)
        }
    }

    @objc private func addTapped() {
        viewModel.addGlass()
        updateUI()
    }
    
    @objc private func reduceTapped() {
        viewModel.removeGlass()
        updateUI()
    }

    private func updateUI() {
        for (index, block) in blocks.enumerated() {
            block.isFilled = index < viewModel.filledCount
        }
        
        totalMlLabel.text = "\(viewModel.totalMl) ml"
    }
}

final class WaterViewModel {

    private let maxGlasses = 8
    private let mlPerGlass = 250

    private let countKey = "water_count"
    private let dateKey = "water_date"

    var filledCount: Int {
        get {
            resetIfNeeded()
            return UserDefaults.standard.integer(forKey: countKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: countKey)
            UserDefaults.standard.set(Date(), forKey: dateKey)
        }
    }

    var totalMl: Int {
        filledCount * mlPerGlass
    }

    func addGlass() {
        guard filledCount < maxGlasses else { return }
        filledCount += 1
    }
    
    func removeGlass() {
        guard filledCount > 0 else { return }
        filledCount -= 1
    }

    private func resetIfNeeded() {
        guard let savedDate = UserDefaults.standard.object(forKey: dateKey) as? Date else {
            UserDefaults.standard.set(Date(), forKey: dateKey)
            return
        }

        if !Calendar.current.isDateInToday(savedDate) {
            UserDefaults.standard.set(0, forKey: countKey)
            UserDefaults.standard.set(Date(), forKey: dateKey)
        }
    }
}


final class WaterBlockView: UIView {

    var isFilled: Bool = false {
        didSet { updateUI() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { nil }

    private func updateUI() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = self.isFilled
                ? UIColor.systemBlue
                : UIColor.systemBlue.withAlphaComponent(0.1)
        }
    }
}

//
//  Step2View.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import UIKit
import SnapKit

final class Step2View: UIView {
    
    private let values = Array(140...220)
    var selectedHeight: Int = 170
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What’s your Height?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let unitButton: UIButton = {
        let button = UIButton()
        button.setTitle("cm ▼", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let picker = UIPickerView()
    
    private let arrowView: UILabel = {
        let label = UILabel()
        label.text = "◀︎"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .clear
        
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(unitButton)
        addSubview(containerView)
        
        containerView.addSubview(picker)
        addSubview(arrowView)
        
        // layout
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        unitButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(32)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(unitButton.snp.bottom).offset(-8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(400)
        }
        
        picker.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints {
            $0.centerY.equalTo(containerView)
            $0.leading.equalTo(containerView.snp.trailing).offset(8)
        }
        
        DispatchQueue.main.async {
            let index = self.values.firstIndex(of: 170) ?? 0
            self.picker.selectRow(index, inComponent: 0, animated: false)
        }
    }
}


extension Step2View: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        44
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHeight = values[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        let value = values[row]
        
        if row == pickerView.selectedRow(inComponent: component) {
            label.text = "\(value) cm"
            label.font = .boldSystemFont(ofSize: 22)
            label.textColor = .black
        } else {
            label.text = "\(value)"
            label.font = .systemFont(ofSize: 18)
            label.textColor = .gray
        }
        
        label.textAlignment = .center
        return label
    }
}


extension Step2View: OnboardingStep {
    func getData() -> Any {
        Step2Data(height: selectedHeight)
    }
}

struct Step2Data {
    let height: Int
}

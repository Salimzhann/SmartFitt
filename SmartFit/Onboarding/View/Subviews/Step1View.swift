//
//  Step1View.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import UIKit
import SnapKit


final class Step1View: UIView {
    
    private let ages = Array(10...100)
    var selectedAge: Int = 25
    
    private let genderSegment: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Male", "Female"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        return seg
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How old are you?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let picker = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setup() {
        backgroundColor = .clear
        
        picker.dataSource = self
        picker.delegate = self
        
        addSubview(genderSegment)
        genderSegment.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(genderSegment.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(picker)
        picker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(300)
        }
        
        DispatchQueue.main.async {
            let index = self.ages.firstIndex(of: 25) ?? 0
            self.picker.selectRow(index, inComponent: 0, animated: false)
        }
    }
}


extension Step1View: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAge = ages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.text = "\(ages[row])"
        label.textAlignment = .center
        
        if row == pickerView.selectedRow(inComponent: component) {
            label.font = .boldSystemFont(ofSize: 32)
            label.textColor = .black
        } else {
            label.font = .systemFont(ofSize: 24)
            label.textColor = .gray
        }
        
        return label
    }
}


extension Step1View: OnboardingStep {
    func getData() -> Any {
        return Step1Data(
            age: selectedAge,
            gender: genderSegment.selectedSegmentIndex == 0 ? "MALE" : "FEMALE"
        )
    }
}

struct Step1Data {
    let age: Int
    let gender: String
}

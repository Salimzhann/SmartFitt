//
//  ActivityOptionView.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import UIKit
import SnapKit


final class ActivityOptionView: UIView {
    
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    private let checkmark = UIImageView()
    
    private var isSelectedState = false
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setup() {
        layer.cornerRadius = 16
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        iconView.image = UIImage(systemName: "chart.bar.fill")
        iconView.tintColor = .systemBlue
        
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")
        checkmark.tintColor = .white
        checkmark.isHidden = true
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(checkmark)
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        checkmark.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    func configure(icon: UIImage, title: String) {
        iconView.image = icon
        titleLabel.text = title
    }
    
    func setSelected(_ selected: Bool) {
        isSelectedState = selected
        
        if selected {
            backgroundColor = .systemBlue.withAlphaComponent(0.9)
            titleLabel.textColor = .white
            iconView.tintColor = .white
            checkmark.isHidden = false
        } else {
            backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            titleLabel.textColor = .black
            iconView.tintColor = .systemBlue
            checkmark.isHidden = true
        }
    }
    
    @objc private func tapped() {
        onTap?()
    }
}

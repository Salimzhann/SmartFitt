//
//  MacroView.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 15.04.2026.
//

import UIKit
import SnapKit


final class MacroView: UIView {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    init(title: String, value: String, progress: Float, color: UIColor) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 14, weight: .bold)
        valueLabel.textAlignment = .right
        
        if Double(progress) >= 1 {
            valueLabel.textColor = .systemRed
        }
        
        progressView.progress = progress
        progressView.tintColor = color
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        
        let topStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [topStack, progressView])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

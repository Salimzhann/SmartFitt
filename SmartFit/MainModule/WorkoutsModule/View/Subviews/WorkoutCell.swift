//
//  WorkoutCell.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 21.02.2026.
//

import UIKit
import SnapKit


enum CellStyle {
    
    case workout
    case exercise
}


final class WorkoutCell: UICollectionViewCell {
    
    static let identifier: String = "WorkoutCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 130, height: 110))
        }
    }
    
    func configureCell(item: WorkoutResponse, style: CellStyle) {
        imageView.image = item.image
        titleLabel.text = item.title
        
        switch style {
        case .exercise:
            contentView.layer.cornerRadius = 16
            contentView.backgroundColor = .systemBackground
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.black.cgColor
            
        case .workout:
            contentView.backgroundColor = .softBlue.withAlphaComponent(0.3)
            contentView.layer.cornerRadius = 16
        }
    }
}

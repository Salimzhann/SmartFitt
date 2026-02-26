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
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let skeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 24
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        skeletonView.layer.removeAllAnimations()
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 24
        
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
        
        contentView.addSubview(skeletonView)
        skeletonView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configureCell(item: WorkoutResponse, style: CellStyle) {
        skeletonView.isHidden = true
        titleLabel.isHidden = false
        imageView.isHidden = false
        
        titleLabel.text = item.name
        guard let url = URL(string: item.imageUrl) else {
            imageView.image = nil
            return
        }
        loadImage(from: url) { [weak self] image in
            self?.imageView.image = image
        }
        
        switch style {
        case .exercise:
            contentView.layer.cornerRadius = 24
            contentView.backgroundColor = .systemBackground
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.black.cgColor
            titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
            
            updateViewConstraints()
            
        case .workout:
            contentView.backgroundColor = .softBlue.withAlphaComponent(0.3)
            contentView.layer.cornerRadius = 24
        }
    }
    
    func configureSkeleton() {
        skeletonView.isHidden = false

        titleLabel.isHidden = true
        imageView.isHidden = true

        contentView.backgroundColor = .systemGray6
        startShimmer()
    }
    
    private func startShimmer() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity
        skeletonView.layer.add(animation, forKey: "shimmer")
    }
    
    private func updateViewConstraints() {
        imageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 130, height: 110))
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(24)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

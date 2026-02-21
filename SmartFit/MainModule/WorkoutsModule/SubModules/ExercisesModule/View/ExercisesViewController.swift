//
//  ExercisesViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 21.02.2026.
//

import UIKit
import SnapKit

public protocol IExercisesView: AnyObject {
    
    var exerciseItems: [WorkoutResponse]? { get set }
    
    func setLoading(isLoading: Bool)
    func reloadData()
}


final class ExercisesViewController: UIViewController, IExercisesView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            WorkoutCell.self,
            forCellWithReuseIdentifier: WorkoutCell.identifier
        )
        return cv
    }()
    
    private let presenter: IExercisesPresenter
    var exerciseItems: [WorkoutResponse]?
    
    init(presenter: IExercisesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setLoading(isLoading: Bool) {
        collectionView.isHidden = isLoading
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}


extension ExercisesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exerciseItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCell.identifier, for: indexPath) as! WorkoutCell
        guard let exerciseItems else { return cell }
        
        cell.configureCell(item: exerciseItems[indexPath.row], style: .exercise)
        return cell
    }
}

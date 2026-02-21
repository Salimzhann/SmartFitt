//
//  WorkoutsViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit

public protocol IWorkoutsView: AnyObject {
    
    var presenter: IWorkoutsPresenter? { get set }
    var workoutItems: [WorkoutResponse]? { get set }
}


final class WorkoutsViewController: UIViewController, IWorkoutsView {
    
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
    
    var workoutItems: [WorkoutResponse]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var presenter: IWorkoutsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
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
}


extension WorkoutsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workoutItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCell.identifier, for: indexPath) as! WorkoutCell
        guard let workoutItems else { return cell }
        
        cell.configureCell(item: workoutItems[indexPath.row], style: .workout)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workout = workoutItems?[indexPath.row]
        
        let repository = WorkoutRepository()
        let presenter = ExercisesPresenter(repository: repository)
        let viewController = ExercisesViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

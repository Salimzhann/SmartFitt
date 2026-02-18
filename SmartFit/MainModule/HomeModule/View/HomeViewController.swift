//
//  HomeViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit

public protocol IHomeViewController: AnyObject {
    
    var habits: [HabitChallengeViewModel] { get set }
    
    func showError(_ message: String)
    func updateProfile(with viewModel: MeResponse)
}


final class HomeViewController: UIViewController, IHomeViewController {
    
    private lazy var profileView: ProfileView = {
       let view = ProfileView()
        view.onLogOut = { [weak presenter] in
            presenter?.logoutTapped()
        }
        return view
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let waterIntakeView = WaterCounterView()
    private let habitChallengeLabel: UILabel = {
        let label = UILabel()
        label.text = "Habit challenges"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 40,
            height: 260
        )
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            HabitChallengeCell.self,
            forCellWithReuseIdentifier: HabitChallengeCell.reuseId
        )
        return cv
    }()
    
    let presenter: IHomePresenter?
    var habits: [HabitChallengeViewModel] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionHeight()
        }
    }
    
    init(presenter: IHomePresenter?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
        profileView.showSkeleton()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        
        contentView.addSubview(waterIntakeView)
        waterIntakeView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(habitChallengeLabel)
        habitChallengeLabel.snp.makeConstraints { make in
            make.top.equalTo(waterIntakeView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(habitChallengeLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    
    func showError(_ message: String) {
        view.endEditing(true)
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateProfile(with viewModel: MeResponse) {
        let date = Date(timeIntervalSince1970: TimeInterval(viewModel.loggedInAt))
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        let formatted = formatter.string(from: date)
        
        profileView.configure(image: .defaultAvatarIc, username: viewModel.email, email: formatted)
        profileView.hideSkeleton()
    }
    
    private func updateCollectionHeight() {
        let itemHeight: CGFloat = 260
        let spacing: CGFloat = 16
        let count = CGFloat(habits.count)

        let totalHeight =
            count * itemHeight +
            max(0, count - 1) * spacing

        collectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HabitChallengeCell.reuseId,
            for: indexPath
        ) as! HabitChallengeCell
        
        cell.onActionTap = { [weak self] in
            
        }
        
        cell.configure(with: habits[indexPath.item])
        return cell
    }
}

//
//  HomeViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit

public protocol IHomeViewController: AnyObject {
    
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
    private let waterIntakeView = WaterCounterView()
    
    let presenter: IHomePresenter?
    
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
        profileView.isUserInteractionEnabled = true
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(waterIntakeView)
        waterIntakeView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
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
}

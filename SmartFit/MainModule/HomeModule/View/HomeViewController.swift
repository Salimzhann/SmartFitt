//
//  HomeViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit

public protocol IHomeViewController: AnyObject {
    
}


final class HomeViewController: UIViewController, IHomeViewController {
    
    private lazy var profileView: ProfileView = {
       let view = ProfileView()
        view.onLogOut = { [weak presenter] in
            presenter?.logoutTapped()
        }
        return view
    }()
    
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
        profileView.configure(image: .defaultAvatarIc, username: "Manas S.", email: "msalimzhan@icloud.com")
        profileView.isUserInteractionEnabled = true
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.trailing.equalToSuperview()
        }
    }
}

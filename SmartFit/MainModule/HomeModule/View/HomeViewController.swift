//
//  HomeViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit


final class HomeViewController: UIViewController {
    
    private let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
        profileView.configure(image: .defaultAvatarIc, username: "Manas S.", email: "msalimzhan@icloud.com")
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

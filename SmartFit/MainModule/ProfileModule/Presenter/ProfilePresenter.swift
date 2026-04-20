//
//  ProfilePresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 15.04.2026.
//

import UIKit

protocol IProfilePresenter: AnyObject {
    
    func logoutTapped()
    func viewDidLoad()
}


class ProfilePresenter: IProfilePresenter {
    
    private weak var view: IProfileView?
    private let repository: IProfileRepository
    
    init(view: IProfileView, repository: IProfileRepository) {
        self.view = view
        self.repository = repository
    }
    
    func viewDidLoad() {
        fetchUserInfo()
    }
    
    func logoutTapped() {
        TokenStorage.shared.clear()
        
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                
                let onboardingVC = OnboardingViewController()
                let nav = UINavigationController(rootViewController: onboardingVC)
                
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        }
    }
    
    private func fetchUserInfo() {
        self.view?.showLoading()
        repository.infoAboutMe { [weak self] response in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let response):
                self?.view?.hideLoading()
                self?.view?.showInfo(data: response)
            }
        }
    }
}

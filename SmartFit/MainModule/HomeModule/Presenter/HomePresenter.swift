//
//  HomePresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 16.02.2026.
//

import UIKit
import Foundation

public protocol IHomePresenter: AnyObject {
    
    func logoutTapped()
}


final class HomePresenter: IHomePresenter {
    
    weak var view: IHomeViewController?
    
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
}

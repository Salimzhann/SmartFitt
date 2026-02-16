//
//  AppDelegate.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 07.02.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            TokenStorage.shared.clear()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        
        let window = UIWindow()
        let viewController: UIViewController
        
        if let token = TokenStorage.shared.getAccessToken(),
           !token.isEmpty {
            viewController = MainTabBarController()
        } else {
            viewController = OnboardingViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}


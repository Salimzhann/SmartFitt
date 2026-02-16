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

        window = UIWindow(frame: UIScreen.main.bounds)

        if let token = TokenStorage.shared.getAccessToken(),
           !token.isEmpty {
            window?.rootViewController = MainTabBarController()
        } else {
            let onboarding = OnboardingViewController()
            window?.rootViewController = UINavigationController(rootViewController: onboarding)
        }

        window?.makeKeyAndVisible()
        return true
    }
}


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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let hasOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        let hasToken = !(TokenStorage.shared.getAccessToken()?.isEmpty ?? true)

        if !hasToken {
            showAuth()
        } else if !hasOnboarding {
            showOnboarding()
        } else {
            showMain()
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    private func showOnboarding() {
        let onboardingRepo = HelperOnboardingRepository()
        let vc = HelperOnboardingViewController()
        let onboardingPresenter = HelperOnboardingPresenter(
            repository: onboardingRepo,
            view: vc
        )
        vc.presenter = onboardingPresenter
        window?.rootViewController = vc
    }

    private func showAuth() {
        let vc = OnboardingViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }

    private func showMain() {
        window?.rootViewController = MainTabBarController()
    }
}


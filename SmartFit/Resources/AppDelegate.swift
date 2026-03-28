//
//  AppDelegate.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 07.02.2026.
//

import UIKit
import UserNotifications


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
        requestNotificationPermission()
        scheduleDailyNotification()
    }
    
    private func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "SmartFit 💪"
        content.body = "Track your food for today!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "daily_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ allowed")
                    self.scheduleDailyNotification()
                } else {
                    print("❌ denied")
                }
            }
        }
    }
}


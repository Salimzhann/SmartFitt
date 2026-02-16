//
//  MainTabBarController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//


import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        // Home Page
        let homePresenter = HomePresenter()
        let homeVC = HomeViewController(presenter: homePresenter)
        homePresenter.view = homeVC
        
        //Chat Page
        let chatVC = ChatViewController()
        
        //Nutrition Page
        let caloriesVC = CaloriesViewController()
        
        // Workout Page
        let workoutsVC = WorkoutsViewController()
        
        homeVC.title = "Home Page"
        caloriesVC.title = "Calories"
        workoutsVC.title = "Workouts"

        let homeNav = UINavigationController(rootViewController: homeVC)
        let chatNav = UINavigationController(rootViewController: chatVC)
        let caloriesNav = UINavigationController(rootViewController: caloriesVC)
        let workoutsNav = UINavigationController(rootViewController: workoutsVC)

        homeNav.tabBarItem = UITabBarItem(
            title: "Home Page",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        chatNav.tabBarItem = UITabBarItem(
            title: "AI Chat",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message.fill")
        )

        caloriesNav.tabBarItem = UITabBarItem(
            title: "Calculate Calories",
            image: UIImage(systemName: "flame"),
            selectedImage: UIImage(systemName: "flame.fill")
        )

        workoutsNav.tabBarItem = UITabBarItem(
            title: "Workout",
            image: UIImage(systemName: "figure.strengthtraining.traditional"),
            selectedImage: UIImage(systemName: "figure.strengthtraining.traditional")
        )

        viewControllers = [
            homeNav,
            chatNav,
            caloriesNav,
            workoutsNav
        ]
    }

    private func setupAppearance() {
        tabBar.unselectedItemTintColor = .systemBlue.withAlphaComponent(0.7)
        tabBar.tintColor = .systemOrange
    }
}

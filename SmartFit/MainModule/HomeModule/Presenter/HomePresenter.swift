//
//  HomePresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 16.02.2026.
//

import UIKit
import Foundation

public protocol IHomePresenter: AnyObject {
    
    func viewDidLoad()
    func logoutTapped()
}


final class HomePresenter: IHomePresenter {
    
    weak var view: IHomeViewController?
    private let repository: IHomeRepository
    
    init(repository: IHomeRepository) {
        self.repository = repository
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
    
    func viewDidLoad() {
        fetchMeData()
        
        var habits = [
            HabitChallengeViewModel(
                id: 1,
                title: "Sleep 8 hours every night",
                activatedTitle: "Sleep 8 hours",
                buttonTitle: "Start",
                backgroundColor: .softBlue.withAlphaComponent(0.2),
                buttonBackgroundColor: .systemBlue,
                image: .nightHabbitIc
            ),
            HabitChallengeViewModel(
                id: 2,
                title: "No fast food for 7 days",
                activatedTitle: "No fast food",
                buttonTitle: "Start",
                backgroundColor: .softOrange.withAlphaComponent(0.2),
                buttonBackgroundColor: .systemOrange,
                image: .foodHabbitIc
            ),
            HabitChallengeViewModel(
                id: 3,
                title: "Do 10,000 steps every day",
                activatedTitle: "Do 10,000 steps",
                buttonTitle: "Start",
                backgroundColor: .softBlue.withAlphaComponent(0.2),
                buttonBackgroundColor: .systemBlue,
                image: .runHabbitIc
            )
        ]
        
        let stored = HabitStorage.load()

           for i in habits.indices {
               let id = habits[i].id
               guard let saved = stored[id] else { continue }

               habits[i].isActive = saved.0
               habits[i].markedDays = saved.1
               habits[i].startDate = saved.2

               // ⛔️ если неделя прошла — деактивируем
               if habits[i].isWeekExpired || habits[i].isCompleted {
                   habits[i].isActive = false
               }
           }

           view?.habits = habits
    }
    
    private func fetchMeData() {
        repository.infoAboutMe { [weak self] data in
            switch data {
            case .success(let data):
                self?.view?.updateProfile(with: data)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}

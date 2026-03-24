//
//  HelperOnboardingPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 17.03.2026.
//

import Foundation

protocol IHelperOnboardingPresenter: AnyObject {
    
    func viewDidload()
    func submit(data: OnboardingData)
}


final class HelperOnboardingPresenter: IHelperOnboardingPresenter {
    
    private let repository: IHelperOnboardingRepository
    weak var view: IHelperOnboardingView?
    
    init(
        repository: IHelperOnboardingRepository,
        view: IHelperOnboardingView?
    ) {
        self.repository = repository
        self.view = view
    }
    
    func viewDidload() {
        
    }
    
    func submit(data: OnboardingData) {
        
        guard
            let age = data.age,
            let height = data.height,
            let weight = data.weight,
            let gender = data.gender,
            let activity = data.activity,
            let goal = data.goal
        else {
            view?.showError("Fill all fields")
            return
        }

        print("""
        🚀 ONBOARDING:
        age: \(age)
        height: \(height)
        weight: \(weight)
        gender: \(gender.rawValue)
        activity: \(activity.rawValue)
        goal: \(goal.rawValue)
        """)

        repository.sendOnboarding(
            data: OnboardingData(
                age: age,
                gender: gender,
                height: height,
                weight: weight,
                activity: activity,
                goal: goal
            )
        ) { [weak self] result in
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.view?.onboardingSuccess()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}

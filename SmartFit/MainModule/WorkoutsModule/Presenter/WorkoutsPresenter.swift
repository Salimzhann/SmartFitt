//
//  WorkoutsPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 21.02.2026.
//

import Foundation

public protocol IWorkoutsPresenter: AnyObject {
    
    func viewDidLoad()
}


final class WorkoutsPresenter: IWorkoutsPresenter {
    
    private let repository: IWorkoutRepository
    weak var view: IWorkoutsView?
    
    init(repository: IWorkoutRepository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        repository.fetchWorkoutList { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.view?.workoutItems = response
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

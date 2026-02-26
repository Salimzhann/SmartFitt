//
//  ExercisesPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 21.02.2026.
//

import Foundation

public protocol IExercisesPresenter: AnyObject {
    
    func viewDidLoad()
}


final class ExercisesPresenter: IExercisesPresenter {
    
    private let repository: IWorkoutRepository
    private let workoutId: Int
    weak var view: IExercisesView?
    
    init(repository: IWorkoutRepository, workoutId: Int) {
        self.repository = repository
        self.workoutId = workoutId
    }
    
    func viewDidLoad() {
        repository.fetchExercisesList(workoutID: workoutId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.view?.exerciseItems = response
                self?.view?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}

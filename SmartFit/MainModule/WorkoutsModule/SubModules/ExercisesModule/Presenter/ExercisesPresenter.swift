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
    weak var view: IExercisesView?
    
    init(repository: IWorkoutRepository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        view?.exerciseItems = [
            WorkoutResponse(
                title: "Chest",
                image: .chestIc
            ),
            WorkoutResponse(
                title: "Chest",
                image: .chestIc
            ),
            WorkoutResponse(
                title: "Chest",
                image: .chestIc
            ),
            WorkoutResponse(
                title: "Chest",
                image: .chestIc
            ),
            WorkoutResponse(
                title: "Chest",
                image: .chestIc
            )
        ]
    }
}

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
        view?.workoutItems = [
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

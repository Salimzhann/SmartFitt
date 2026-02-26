//
//  WorkoutRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 21.02.2026.
//

import Foundation

protocol IWorkoutRepository {
    
    func fetchWorkoutList(completion: @escaping (Result<[WorkoutResponse], Error>) -> Void)
    func fetchExercisesList(workoutID: Int, completion: @escaping (Result<[WorkoutResponse], Error>) -> Void)
    func fetchDetailInformation(exerciseID: Int, completion: @escaping (Result<ExerciseDetailsResponse, any Error>) -> Void)
}


final class WorkoutRepository: IWorkoutRepository {
    
    func fetchWorkoutList(completion: @escaping (Result<[WorkoutResponse], any Error>) -> Void) {
        NetworkManager.shared.request(.fetchWorkoutsList, completion: completion)
    }
    
    func fetchExercisesList(workoutID: Int, completion: @escaping (Result<[WorkoutResponse], any Error>) -> Void) {
        NetworkManager.shared.request(.fetchExercisesList(id: workoutID), completion: completion)
    }
    
    func fetchDetailInformation(exerciseID: Int, completion: @escaping (Result<ExerciseDetailsResponse, any Error>) -> Void) {
        NetworkManager.shared.request(.fetchExerciseDetails(id: exerciseID), completion: completion)
    }
}

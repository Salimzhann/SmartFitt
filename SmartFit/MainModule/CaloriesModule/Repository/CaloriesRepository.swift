//
//  CaloriesRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.03.2026.
//

import Moya
import Foundation

protocol ICaloriesRepository: AnyObject {
    
    func fetchCalories(completion: @escaping (Result<[CaloriesResponse], Error>) -> Void)
    func uploadNutrition(
        imageData: Data,
        completion: @escaping (Result<NutritionResponse, Error>) -> Void
    )
}

final class CaloriesRepository: ICaloriesRepository {

    func fetchCalories(completion: @escaping (Result<[CaloriesResponse], Error>) -> Void) {
        NetworkManager.shared.request(.fetchCalories, completion: completion)
    }
    
    func uploadNutrition(
        imageData: Data,
        completion: @escaping (Result<NutritionResponse, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            .uploadNutrition(photo: imageData),
            completion: completion
        )
    }
}

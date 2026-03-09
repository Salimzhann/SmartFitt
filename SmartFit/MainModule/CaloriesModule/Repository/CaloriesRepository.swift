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
}

final class CaloriesRepository: ICaloriesRepository {

    func fetchCalories(completion: @escaping (Result<[CaloriesResponse], Error>) -> Void) {
        
        //        NetworkManager.shared.request(.fetchCalories, completion: completion)
        
        let mock: [CaloriesResponse] = [
            CaloriesResponse(
                kcal: 1223,
                protein: 49,
                fat: 70,
                carbs: 180,
                servingAmount: 320,
                servingUnit: "g",
                calculatedAt: "2026-02-02"
            ),
            CaloriesResponse(
                kcal: 1343,
                protein: 59,
                fat: 73,
                carbs: 184,
                servingAmount: 325,
                servingUnit: "g",
                calculatedAt: "2026-02-03"
            ),
            CaloriesResponse(
                kcal: 1500,
                protein: 70,
                fat: 65,
                carbs: 210,
                servingAmount: 340,
                servingUnit: "g",
                calculatedAt: "2026-02-04"
            )
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(mock))
        }
    }
}

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
                calculatedAt: "2026-02-02",
                meals: [
                    .init(name: "Plov", kcal: "880"),
                    .init(name: "Beshbarmak", kcal: "1 230"),
                    .init(name: "Apple", kcal: "40"),
                    .init(name: "Snickers", kcal: "600"),
                    .init(name: "Nuts (300 gr)", kcal: "180"),
                    .init(name: "Protein Smoothie", kcal: "130")
                ]
            ),
            CaloriesResponse(
                kcal: 1343,
                protein: 59,
                fat: 73,
                carbs: 184,
                servingAmount: 325,
                servingUnit: "g",
                calculatedAt: "2026-02-03",
                meals: [
                    .init(name: "Lagman", kcal: "930"),
                    .init(name: "Quyrdaq", kcal: "1 110"),
                    .init(name: "Banana", kcal: "24"),
                    .init(name: "Bounty", kcal: "410")
                ]
            ),
            CaloriesResponse(
                kcal: 1500,
                protein: 70,
                fat: 65,
                carbs: 210,
                servingAmount: 340,
                servingUnit: "g",
                calculatedAt: "2026-02-04",
                meals: [
                    .init(name: "Cheese Burger", kcal: "920"),
                    .init(name: "Manty", kcal: "1 020"),
                    .init(name: "Strawberry", kcal: "63"),
                    .init(name: "Cake", kcal: "729"),
                    .init(name: "Rice Porridge", kcal: "110")
                ]
            )
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(mock))
        }
    }
}

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
        NetworkManager.shared.request(.fetchCalories, completion: completion)
    }
}

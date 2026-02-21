//
//  HabitStorage.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 19.02.2026.
//

import Foundation


final class HabitStorage {

    private static let key = "stored_habits"

    static func save(_ habits: [HabitChallengeViewModel]) {
        let data = habits.map { habit in
            [
                "id": habit.id,
                "isActive": habit.isActive,
                "markedDays": habit.markedDays,
                "startDate": habit.startDate ?? ""
            ] as [String : Any]
        }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load() -> [Int: (Bool, [String], String?)] {
        guard let data = UserDefaults.standard.array(forKey: key) as? [[String: Any]] else {
            return [:]
        }

        var result: [Int: (Bool, [String], String?)] = [:]

        for item in data {
            guard let id = item["id"] as? Int else { continue }
            let isActive = item["isActive"] as? Bool ?? false
            let marked = item["markedDays"] as? [String] ?? []
            let start = item["startDate"] as? String
            result[id] = (isActive, marked, start)
        }

        return result
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

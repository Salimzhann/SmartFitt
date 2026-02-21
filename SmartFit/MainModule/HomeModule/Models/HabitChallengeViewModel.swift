//
//  HabitChallengeViewModel.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.02.2026.
//

import UIKit

public struct HabitChallengeViewModel {
    
    let id: Int
    let title: String
    let activatedTitle: String
    let buttonTitle: String
    let backgroundColor: UIColor
    let buttonBackgroundColor: UIColor
    let image: UIImage?
    
    // Active state
    var isActive: Bool = false
    var markedDays: [String] = []
    let totalDays: Int = 7
    
    
    var startDate: String? = nil   // "yyyy-MM-dd"
    
    var completedDays: Int { markedDays.count }
    
    var isMarkedToday: Bool {
        markedDays.contains(Self.todayString())
    }
    
    var isCompleted: Bool {
        completedDays >= totalDays
    }
    
    var isWeekExpired: Bool {
        guard let startDate else { return false }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let start = formatter.date(from: startDate) else { return false }
        let end = Calendar.current.date(byAdding: .day, value: totalDays, to: start) ?? start
        return Date() >= end
    }
    
    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

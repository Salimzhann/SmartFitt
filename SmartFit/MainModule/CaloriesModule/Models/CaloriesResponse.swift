//
//  CaloriesResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.03.2026.
//


struct CaloriesResponse: Decodable {
    
    let kcal: Int
    let protein: Int
    let fat: Int
    let carbs: Int
    let servingAmount: Int
    let servingUnit: String
    let calculatedAt: String

    enum CodingKeys: String, CodingKey {
        
        case kcal
        case protein
        case fat
        case carbs
        case servingAmount = "serving_amount"
        case servingUnit = "serving_unit"
        case calculatedAt = "calculated_at"
    }
}

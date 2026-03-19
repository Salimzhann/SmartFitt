//
//  NutritionResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//

import Foundation


struct NutritionResponse: Decodable {
    
    let kcal: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let servingAmount: Double
    let servingUnit: String
    let userId: Int
    let mealName: String
    let foodImageUrl: String
    let id: Int
    let createdAt: String
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case kcal
        case protein
        case carbs
        case fat
        case servingAmount = "serving_amount"
        case servingUnit = "serving_unit"
        case userId = "user_id"
        case mealName = "meal_name"
        case foodImageUrl = "food_image_url"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

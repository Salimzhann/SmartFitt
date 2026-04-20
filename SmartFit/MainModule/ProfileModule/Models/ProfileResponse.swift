//
//  ProfileResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 19.04.2026.
//


struct ProfileResponse: Decodable {
    
    let userEmail: String
    let height: Int
    let weight: Int
    let weekNutrition: WeekNutritionDTO
    
    enum CodingKeys: String, CodingKey {
        case userEmail = "user_email"
        case height
        case weight
        case weekNutrition = "week_nutrition"
    }
}

struct WeekNutritionDTO: Decodable {
    let totalKcal: Double
    let outOfKcal: Double
    let totalProtein: Double
    let totalCarbs: Double
    let totalFats: Double
    let totalServingAmount: Double
    
    enum CodingKeys: String, CodingKey {
        case totalKcal = "total_kcal"
        case outOfKcal = "out_of_kcal"
        case totalProtein = "total_protein"
        case totalCarbs = "total_carbs"
        case totalFats = "total_fats"
        case totalServingAmount = "total_serving_amount"
    }
}

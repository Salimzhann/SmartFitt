//
//  CaloriesResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.03.2026.
//


struct CaloriesResponse: Decodable {
    
    let nutritionDate: String
    let weight: Weight
    let meals: [Meal]
    
    enum CodingKeys: String, CodingKey {
        
        case nutritionDate = "nutrition_date"
        case weight
        case meals
    }
}


struct Weight: Decodable {
    
    let kcal: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let servingAmount: Double
    let servingUnit: String
    
    enum CodingKeys: String, CodingKey {
        
        case kcal
        case protein
        case carbs
        case fat
        case servingAmount = "serving_amount"
        case servingUnit = "serving_unit"
    }
}


struct Meal: Decodable {
    
    let name: String
    let kcal: Double
}

//
//  OnboardingData.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 18.03.2026.
//


enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
}

enum ActivityLevel: String {
    case beginner = "BEGINNER"
    case intermediate = "INTERMEDIATE"
    case advanced = "ADVANCED"
}

enum Goal: String {
    case looseWeight = "LOOSE_WEIGHT"
    case buildMuscle = "BUILD_MUSCLE"
    case stayFit = "STAY_FIT"
    case improveFlexibility = "IMPROVE_FLEXIBILITY"
}


struct OnboardingData {
    
    var age: Int?
    var gender: Gender?
    var height: Int?
    var weight: Int?
    var activity: ActivityLevel?
    var goal: Goal?
}

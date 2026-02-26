//
//  ExerciseDetailsResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 22.02.2026.
//

import Foundation

struct ExerciseDetailsResponse: Decodable {
    
    let id: Int
    let bodyAreaId: Int
    let name: String
    let duration: String
    let calories: String
    let sets: String
    let reps: String
    let videoUrl: String
    let imageUrl: String
    let createdAt: String?
    let updatedAt: String?
    let benefits: [String]

    enum CodingKeys: String, CodingKey {
        
        case id
        case bodyAreaId = "body_area_id"
        case name, duration, calories, sets, reps
        case videoUrl = "video_url"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case benefits
    }
}

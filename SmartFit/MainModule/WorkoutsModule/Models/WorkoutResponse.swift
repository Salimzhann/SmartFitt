//
//  WorkoutResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 21.02.2026.
//

import UIKit

public struct WorkoutResponse: Decodable {
  
    let id: Int
    let name: String
    let imageUrl: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
       
        case id
        case name
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

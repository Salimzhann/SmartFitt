//
//  ChatResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 28.02.2026.
//

import Foundation


struct ChatResponse: Codable {

    let id: Int
    let role: ChatRole
    let content: String
    let userId: Int
    let createdAt: Date
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        
        case id
        case role
        case content
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


enum ChatRole: String, Codable {
    
    case user = "USER"
    case assistant = "FITNESS_ASSISTANT"
}

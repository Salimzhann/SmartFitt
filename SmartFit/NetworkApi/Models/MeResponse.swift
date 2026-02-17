//
//  MeResponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 16.02.2026.
//


public struct MeResponse: Decodable {
    
    let email: String
    let loggedInAt: Int

    enum CodingKeys: String, CodingKey {
        case email
        case loggedInAt = "logged_in_at"
    }
}

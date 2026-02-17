//
//  LoginRequestDTO.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.02.2026.
//

// MARK: - Requests
struct LoginRequest: Encodable {
    
    let email: String
    let password: String
}


//MARK: - Login Repsonse
struct LoginResponse: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
}

// MARK: - Refresh Reposponse
struct RefreshResponse: Decodable {
    let accessToken: String
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

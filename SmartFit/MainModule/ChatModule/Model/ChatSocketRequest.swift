//
//  ChatSocketRequest.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 01.03.2026.
//

import Foundation


struct ChatSocketRequest: Codable {
    let role: ChatRole
    let content: String
}

struct ChatSocketResponse: Codable {
    let role: ChatRole
    let content: String
}

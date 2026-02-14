//
//  APIError.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import Foundation


public enum APIError: LocalizedError {
    case server(message: String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        case .unknown:
            return "Something went wrong"
        }
    }
}


public struct APIErrorResponse: Decodable {
    let detail: String
}

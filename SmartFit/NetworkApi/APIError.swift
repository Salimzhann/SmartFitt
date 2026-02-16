//
//  APIError.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import Foundation


struct APIErrorResponse: Decodable {
    let detail: APIErrorDetail
}


struct APIErrorDetail: Decodable {
    let error: String
}

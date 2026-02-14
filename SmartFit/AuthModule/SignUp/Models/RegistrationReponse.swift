//
//  RegistrationReponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import Foundation


struct RegistrationResponse: Decodable {
    
    let otpID: String
    
    enum CodingKeys: String, CodingKey {
        
        case otpID = "otp_id"
    }
        
}

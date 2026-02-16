//
//  RegistrationReponse.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import Foundation


struct RegistrationResponse: Decodable {
    
    let verificationID: Int
    let resendTime: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case verificationID = "verification_id"
        case resendTime = "resend_in"
    }
}

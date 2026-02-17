//
//  AuthAPI.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.02.2026.
//

import Moya
import Alamofire
import Foundation


enum NetworkAPI {

    // Auth Endpoint
    case register(email: String, password: String)
    case login(email: String, password: String)
    case verifyCode(otpID: Int, code: String)
    case resendCode(verificationID: Int)
    case refresh(refreshToken: String)
    
    // Home Page Endpoint
    case infoMe
}

extension NetworkAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://smartfitness-production.up.railway.app")!
    }

    var path: String {
        switch self {
            
            // Auth Endpoint
        case .register:                 return "/api/v1/auth/register"
        case .login:                    return "/api/v1/auth/login"
        case .verifyCode:               return "/api/v1/auth/register/otp/confirm"
        case .resendCode:               return "/api/v1/auth/register/otp/resend"
        case .refresh:                  return "/api/v1/auth/refresh"
            
            // Home Page Endpoint
        case .infoMe:                   return "/api/v1/auth/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .infoMe:
            return .get
        default:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .login(email, password),
             let .register(email, password):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "password": password
                ],
                encoding: JSONEncoding.default
            )

        case let .verifyCode(otpID, code):
            return .requestParameters(
                parameters: [
                    "verification_id": otpID,
                    "code": code
                ],
                encoding: JSONEncoding.default
            )

        case let .resendCode(verificationID):
            return .requestParameters(
                parameters: [
                    "verification_id": verificationID
                ],
                encoding: JSONEncoding.default
            )
            
        case let .refresh(refreshToken):
            return .requestParameters(
                parameters: [
                    "refresh_token": refreshToken
                ],
                encoding: JSONEncoding.default
            )
            
        case .infoMe:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var sampleData: Data { Data() }
}

// MARK: - Auth helpers
extension NetworkAPI {

    var isAuthEndpoint: Bool {
        switch self {
        case .login,
             .register,
             .verifyCode,
             .resendCode,
             .refresh:
            return true
            
        default:
            return false
        }
    }
}

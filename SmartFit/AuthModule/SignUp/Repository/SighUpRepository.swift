//
//  SighUpRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import Moya
import Foundation

protocol ISignUpRepository {
    
    func register(
        email: String,
        password: String,
        completion: @escaping (Result<RegistrationResponse, Error>) -> Void
    )
    func verifyOTP(
        otpID: Int,
        code: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    )
    func resendCode(
        verificationID: Int,
        completion: @escaping (Result<RegistrationResponse, Error>) -> Void
    )
}


final class SignUpRepository: ISignUpRepository {
    
    private let provider: MoyaProvider<NetworkAPI>
    
    init(provider: MoyaProvider<NetworkAPI> = MoyaProvider<NetworkAPI>()) {
        self.provider = provider
    }
    
    func register(
        email: String,
        password: String,
        completion: @escaping (Result<RegistrationResponse, Error>) -> Void
    ) {
        provider.request(.register(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    do {
                        let decoded = try JSONDecoder().decode(RegistrationResponse.self, from: response.data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    do {
                        let apiError = try JSONDecoder().decode(APIErrorResponse.self, from: response.data)
                        
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: apiError.detail.error]
                        )))
                        
                    } catch {
                        print("Decoding error:", error)
                        print(String(data: response.data, encoding: .utf8) ?? "no data")
                        
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Login failed"]
                        )))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyOTP(
        otpID: Int,
        code: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        provider.request(.verifyCode(otpID: otpID, code: code)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    do {
                        let decoded = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    do {
                        let apiError = try JSONDecoder().decode(APIErrorResponse.self, from: response.data)
                        
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: apiError.detail.error]
                        )))
                        
                    } catch {
                        print("Decoding error:", error)
                        print(String(data: response.data, encoding: .utf8) ?? "no data")
                        
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Login failed"]
                        )))
                    }
                }
                
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resendCode(
        verificationID: Int,
        completion: @escaping (Result<RegistrationResponse, Error>) -> Void
    ) {
        provider.request(.resendCode(verificationID: verificationID)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    do {
                        let decoded = try JSONDecoder().decode(RegistrationResponse.self, from: response.data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    do {
                        let apiError = try JSONDecoder().decode(APIErrorResponse.self, from: response.data)
                        
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: apiError.detail.error]
                        )))
                        
                    } catch {
                        print("Decoding error:", error)
                        print(String(data: response.data, encoding: .utf8) ?? "no data")
                        
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Login failed"]
                        )))
                    }
                }
                
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

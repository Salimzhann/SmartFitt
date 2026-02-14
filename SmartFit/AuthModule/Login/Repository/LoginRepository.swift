//
//  LoginRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.02.2026.
//

import Moya
import Foundation

protocol ILoginRepository {
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    )
}


final class LoginRepository: ILoginRepository {

    private let provider: MoyaProvider<NetworkAPI>

    init(provider: MoyaProvider<NetworkAPI> = MoyaProvider<NetworkAPI>()) {
        self.provider = provider
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        provider.request(.login(email: email, password: password)) { result in
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
                    if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: response.data) {
                        completion(.failure(NSError(
                            domain: "AuthAPI",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: apiError.detail]
                        )))
                    } else {
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

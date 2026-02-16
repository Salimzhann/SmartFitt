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

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            .login(email: email, password: password),
            completion: completion
        )
    }
}

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

    func register(
        email: String,
        password: String,
        completion: @escaping (Result<RegistrationResponse, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            .register(email: email, password: password),
            completion: completion
        )
    }

    func verifyOTP(
        otpID: Int,
        code: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            .verifyCode(otpID: otpID, code: code),
            completion: completion
        )
    }

    func resendCode(
        verificationID: Int,
        completion: @escaping (Result<RegistrationResponse, Error>) -> Void
    ) {
        NetworkManager.shared.request(
            .resendCode(verificationID: verificationID),
            completion: completion
        )
    }
}

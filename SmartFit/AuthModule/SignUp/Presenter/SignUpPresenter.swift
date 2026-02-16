//
//  SignUpPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 07.02.2026.
//

import Foundation

public protocol ISignUpPresenter: AnyObject {
    
    func confirmButtonTapped(email: String, password: String)
}

final class SignUpPresenter: ISignUpPresenter {
    
    weak var view: ISignUpViewController?
    private let repository: ISignUpRepository
    
    init(repository: ISignUpRepository) {
        self.repository = repository
    }
    
    func confirmButtonTapped(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            view?.showError("Email and password are required")
            return
        }
        view?.showLoading()
        repository
            .register(
                email: email,
                password: password
            ) { [weak self] result in
            self?.view?.hideLoading()
            
            switch result {
            case .success(let response):
                self?.view?.signUpSuccess(otpID: response.verificationID)
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}

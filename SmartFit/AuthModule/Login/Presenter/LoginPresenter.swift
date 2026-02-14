//
//  LoginPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 08.02.2026.
//

import Foundation

public protocol ILoginPresenter: AnyObject {
    
    func loginButtonTapped(email: String, password: String)
}


final class LoginPresenter: ILoginPresenter {
    
    private let repository: ILoginRepository
    weak var view: ILoginViewController?
    
    init(repository: ILoginRepository) {
        self.repository = repository
    }
    
    func loginButtonTapped(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            view?.showError("Email and password are required")
            return
        }
        view?.showLoading()
        repository
            .login(
                email: email,
                password: password
            ) { [weak self] result in
            self?.view?.hideLoading()
            
            switch result {
            case .success(let response):
                print("ACCESS:", response.accessToken)
                print("REFRESH:", response.refreshToken)
                self?.view?.loginSuccess()
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}

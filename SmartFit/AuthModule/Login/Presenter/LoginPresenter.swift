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
                guard let self else { return }
                view?.hideLoading()
                
                switch result {
                case .success(let response):
                    TokenStorage.shared.save(
                        accessToken: response.accessToken,
                        refreshToken: response.refreshToken
                    )
                    view?.loginSuccess()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    view?.showError(error.localizedDescription)
                }
            }
    }
}

//
//  OTPPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import Foundation

public protocol IOTPPresenter: AnyObject {
    
    func confirmTapped(code: String)
    func resendOTPTapped()
}


final class OTPPresenter: IOTPPresenter {
    
    weak var view: IOtpViewController?
    private let repository: ISignUpRepository
    private let otpID: String
    
    init(otpID: String, repository: ISignUpRepository) {
        self.repository = repository
        self.otpID = otpID
    }
    
    func confirmTapped(code: String) {
        view?.showLoading()
        repository
            .verifyOTP(otpID: otpID, code: code) { [weak self] result in
                switch result {
                case .success(let result):
                    self?.view?.hideLoading()
                    self?.view?.presentHomePage()
                    
                case .failure(let error):
                    self?.view?.hideLoading()
                    self?.view?.showError(error.localizedDescription)
                }
            }
    }
    
    func resendOTPTapped() {
        
    }
}

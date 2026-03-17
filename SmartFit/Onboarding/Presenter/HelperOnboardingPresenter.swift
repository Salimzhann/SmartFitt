//
//  HelperOnboardingPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 17.03.2026.
//

import Foundation

protocol IHelperOnboardingPresenter: AnyObject {
    
    func viewDidload()
}


final class HelperOnboardingPresenter: IHelperOnboardingPresenter {
    
    private let repository: IHelperOnboardingRepository
    weak var view: IHelperOnboardingView?
    
    init(
        repository: IHelperOnboardingRepository,
        view: IHelperOnboardingView?
    ) {
        self.repository = repository
        self.view = view
    }
    
    func viewDidload() {
        
    }
}

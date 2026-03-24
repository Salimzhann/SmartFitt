//
//  HelperOnboardingRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 17.03.2026.
//

import Foundation

protocol IHelperOnboardingRepository: AnyObject {
    
    func sendOnboarding(data: OnboardingData, completion: @escaping (Result<Void, Error>) -> Void)
}


final class HelperOnboardingRepository: IHelperOnboardingRepository {
    
    func sendOnboarding(data: OnboardingData, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.requestWithoutDecoding(.onboarding(data: data), completion: completion)
    }
}

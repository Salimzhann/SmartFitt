//
//  ProfileRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 15.04.2026.
//

import Moya
import Foundation

protocol IProfileRepository {
    
    func infoAboutMe(completion: @escaping (Result<ProfileResponse, Error>) -> Void)
}


final class ProfileRepository: IProfileRepository {

    func infoAboutMe(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        NetworkManager.shared.request(.fetchProfile, completion: completion)
    }
}


//
//  HomeRepository.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 16.02.2026.
//

import Moya
import Foundation

protocol IHomeRepository {
    
    func infoAboutMe(completion: @escaping (Result<MeResponse, Error>) -> Void)
}


final class HomeRepository: IHomeRepository {

    func infoAboutMe(completion: @escaping (Result<MeResponse, Error>) -> Void) {
        NetworkManager.shared.request(.infoMe, completion: completion)
    }
}


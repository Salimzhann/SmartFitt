//
//  ChatRepoitory.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 28.02.2026.
//

import Foundation


protocol IChatRepoitory: AnyObject {
    
    func fetchHistory(completion: @escaping (Result<[ChatResponse], Error>) -> Void)
    func deleteHistory(completion: @escaping (Result<Void, Error>) -> Void)
}


class ChatRepoitory: IChatRepoitory {
    
    func fetchHistory(completion: @escaping (Result<[ChatResponse], Error>) -> Void) {
        NetworkManager.shared.request(.fetchChatHistory, completion: completion)
    }
    
    func deleteHistory(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.requestWithoutDecoding(.deleteChatHistory) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


struct EmptyResponse: Decodable { }

//
//  ChatRepoitory.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 28.02.2026.
//

import Foundation


protocol IChatRepoitory: AnyObject {
    
    func fetchHistory(completion: @escaping (Result<[ChatResponse], Error>) -> Void)
}


class ChatRepoitory: IChatRepoitory {
    
    func fetchHistory(completion: @escaping (Result<[ChatResponse], Error>) -> Void) {
        NetworkManager.shared.request(.fetchChatHistory, completion: completion)
    }
}

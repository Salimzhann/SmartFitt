//
//  ChatPresenter.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 28.02.2026.
//

import Foundation

protocol IChatPresenter: AnyObject {
    
    func viewDidLoad()
    func sendMessage(_ text: String)
}


class ChatPresenter: IChatPresenter {
    
    weak var view: IChatView?
    private let repository: IChatRepoitory
    private var messages: [ChatMessageViewModel] = []
    
    init(repository: IChatRepoitory) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        fetchHistory()
    }
    
    private func fetchHistory() {
        repository.fetchHistory { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.messages = response.map {
                    ChatMessageViewModel(
                        id: $0.id,
                        text: $0.content,
                        isIncoming: $0.role == .assistant
                    )
                }
                
                DispatchQueue.main.async {
                    self.view?.updateMessages(self.messages)
                }
                
            case .failure(let error):
                print("CHAT ERROR:", error)
            }
        }
    }
    
    func sendMessage(_ text: String) {
        let localMessage = ChatMessageViewModel(
                id: UUID().hashValue,
                text: text,
                isIncoming: false
            )

            messages.append(localMessage)
            view?.updateMessages(messages)

            // 2️⃣ отправка на сервер
//            repository.sendMessage(text: text) { [weak self] result in
//                guard let self else { return }
//
//                switch result {
//                case .success(let response):
//                    // 3️⃣ серверная история (user + assistant)
//                    self.messages = response.map {
//                        ChatMessageViewModel(
//                            id: $0.id,
//                            text: $0.content,
//                            isIncoming: $0.role == .assistant
//                        )
//                    }
//
//                    DispatchQueue.main.async {
//                        self.view?.updateMessages(self.messages)
//                    }
//
//                case .failure(let error):
//                    print("SEND MESSAGE ERROR:", error)
//                    // тут можно:
//                    // - показать toast
//                    // - пометить сообщение как failed
//                }
//            }
    }
}

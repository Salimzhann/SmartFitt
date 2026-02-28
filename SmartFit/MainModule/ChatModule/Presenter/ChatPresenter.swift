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


final class ChatPresenter: IChatPresenter {

    weak var view: IChatView?
    private let service: IChatService

    private var messages: [ChatMessageViewModel] = []

    init(service: IChatService) {
        self.service = service
    }

    func viewDidLoad() {
        service.onMessage = { [weak self] message in
            guard let self else { return }
            self.messages.append(message)
            self.view?.updateMessages(self.messages)
        }

        service.enterChat()
    }

    func sendMessage(_ text: String) {
        let local = ChatMessageViewModel(
            id: UUID().hashValue,
            text: text,
            isIncoming: false
        )

        messages.append(local)
        view?.updateMessages(messages)
        service.sendMessage(text)
    }

    func viewDidDisappear() {
        service.leaveChat()
    }
}

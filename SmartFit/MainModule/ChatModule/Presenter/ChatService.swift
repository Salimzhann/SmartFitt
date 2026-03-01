//
//  ChatService.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 01.03.2026.
//

import Foundation

protocol IChatService: AnyObject {
 
    func enterChat()
    func leaveChat()
    func sendMessage(_ text: String)
    func deleteHistory()
    
    var onMessage: ((ChatMessageViewModel) -> Void)? { get set }
    var onHistory: (([ChatMessageViewModel]) -> Void)? { get set }
    var onHistoryCleared: (() -> Void)? { get set }
}


final class ChatService: IChatService {

    private var socket: URLSessionWebSocketTask?
    private var disconnectTimer: Timer?

    private let repository: IChatRepoitory
    private let tokenProvider: () -> String?

    var onMessage: ((ChatMessageViewModel) -> Void)?
    var onHistory: (([ChatMessageViewModel]) -> Void)?
    var onHistoryCleared: (() -> Void)?

    init(
        repository: IChatRepoitory,
        tokenProvider: @escaping () -> String?
    ) {
        self.repository = repository
        self.tokenProvider = tokenProvider
    }

    // MARK: - Enter Chat

    func enterChat() {
        // ❗ отменяем возможное закрытие
        disconnectTimer?.invalidate()
        disconnectTimer = nil

        // если сокет уже жив — ничего не делаем
        if socket != nil { return }

        // 1️⃣ сперва грузим историю
        fetchHistoryAndConnect()
    }
    
    func deleteHistory() {
        repository.deleteHistory { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.closeSocket()
                    self?.onHistoryCleared?()
                }
            case .failure(let error):
                print("DELETE CHAT ERROR:", error)
            }
        }
    }
    
    private func fetchHistoryAndConnect() {
        repository.fetchHistory { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let result):
                let history = result.map {
                    ChatMessageViewModel(
                        id: $0.id,
                        text: $0.content,
                        isIncoming: $0.role == .assistant
                    )
                }
                
                DispatchQueue.main.async {
                    self.onHistory?(history)
                    self.openSocket()
                }
                
            case .failure(let error):
                print("CHAT HISTORY ERROR:", error)
            }
        }
    }

    // MARK: - WebSocket

    private func openSocket() {
        guard let token = tokenProvider() else { return }

        let url = URL(string: "wss://smartfitness-production.up.railway.app/api/v1/ai-chat/ws/\(token)")!
        let session = URLSession(configuration: .default)
        socket = session.webSocketTask(with: url)
        socket?.resume()

        listen()
    }

    private func listen() {
        socket?.receive { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let message):
                if case .string(let text) = message,
                   let data = text.data(using: .utf8),
                   let response = try? JSONDecoder().decode(ChatSocketResponse.self, from: data) {

                    let viewModel = ChatMessageViewModel(
                        id: UUID().hashValue,
                        text: response.content,
                        isIncoming: response.role == .assistant
                    )

                    DispatchQueue.main.async {
                        self.onMessage?(viewModel)
                    }
                }

                // слушаем дальше
                self.listen()

            case .failure(let error):
                print("WS ERROR:", error)
                self.socket = nil
            }
        }
    }

    // MARK: - Send

    func sendMessage(_ text: String) {
        let payload = ChatSocketRequest(
            role: .user,
            content: text
        )

        guard
            let data = try? JSONEncoder().encode(payload),
            let json = String(data: data, encoding: .utf8)
        else { return }

        socket?.send(.string(json)) { error in
            if let error {
                print("SEND ERROR:", error)
            }
        }
    }

    // MARK: - Leave Chat

    func leaveChat() {
        // ❗ не закрываем сразу
        disconnectTimer = Timer.scheduledTimer(
            withTimeInterval: 60,
            repeats: false
        ) { [weak self] _ in
            self?.closeSocket()
        }
    }

    private func closeSocket() {
        socket?.cancel(with: .goingAway, reason: nil)
        socket = nil
    }
    
    func fetchHistory(completion: @escaping ([ChatMessageViewModel]) -> Void) {
        repository.fetchHistory { result in
            switch result {
            case .success(let response):
                let messages = response.map {
                    ChatMessageViewModel(
                        id: $0.id,
                        text: $0.content,
                        isIncoming: $0.role == .assistant
                    )
                }
                DispatchQueue.main.async {
                    completion(messages)
                }

            case .failure(let error):
                print("CHAT HISTORY ERROR:", error)
                completion([])
            }
        }
    }
}

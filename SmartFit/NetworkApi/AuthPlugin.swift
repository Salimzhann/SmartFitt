//
//  AuthPlugin.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 16.02.2026.
//

import Moya
import UIKit
import Foundation


final class AuthPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let api = target as? NetworkAPI else { return request }
        guard api.isAuthEndpoint == false else { return request }

        var request = request
        if let token = TokenStorage.shared.getAccessToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}


final class NetworkManager {

    static let shared = NetworkManager()

    private let provider = MoyaProvider<NetworkAPI>(
        plugins: [AuthPlugin()]
    )

    private var isRefreshing = false
    private var retryQueue: [() -> Void] = []

    private init() {}

    func request<T: Decodable>(
        _ target: NetworkAPI,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):

                // ❌ 401 НА AUTH — ВОЗВРАЩАЕМ ОШИБКУ
                if response.statusCode == 401, target.isAuthEndpoint {
                    completion(.failure(response.mapAPIError()))
                    return
                }

                // 🔄 401 НА ОБЫЧНЫХ ЗАПРОСАХ
                if response.statusCode == 401 {
                    self.enqueue {
                        self.request(target, completion: completion)
                    }
                    self.refreshIfNeeded()
                    return
                }

                // ✅ SUCCESS
                if (200...299).contains(response.statusCode) {
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: response.data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(response.mapAPIError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Refresh
    private func refreshIfNeeded() {
        guard !isRefreshing else { return }
        guard let refreshToken = TokenStorage.shared.getRefreshToken() else {
            logout()
            return
        }

        isRefreshing = true
        provider.request(.refresh(refreshToken: refreshToken)) { [weak self] result in
            guard let self else { return }
            self.isRefreshing = false

            switch result {
            case .success(let response):
                guard
                    (200...299).contains(response.statusCode),
                    let decoded = try? JSONDecoder().decode(RefreshResponse.self, from: response.data)
                else {
                    print("REFRESH BODY:", String(data: response.data, encoding: .utf8) ?? "no body")
                    self.logout()
                    return
                }

                TokenStorage.shared.save(
                    accessToken: decoded.accessToken,
                    refreshToken: TokenStorage.shared.getRefreshToken() ?? ""
                )

                self.retryQueue.forEach { $0() }
                self.retryQueue.removeAll()

            case .failure(let error):
                print(error.errorCode, error)
                self.logout()
            }
        }
    }

    private func enqueue(_ block: @escaping () -> Void) {
        retryQueue.append(block)
    }

    // MARK: - Logout

    private func logout() {
        TokenStorage.shared.clear()

        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                window.rootViewController =
                    UINavigationController(rootViewController: OnboardingViewController())
                window.makeKeyAndVisible()
            }
        }
    }
}

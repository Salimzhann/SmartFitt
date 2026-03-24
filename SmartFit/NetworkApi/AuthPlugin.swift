//
//  AuthPlugin.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 16.02.2026.
//

import Moya
import UIKit
import Alamofire
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
                
                print("➡️ [\(target.path)] STATUS:", response.statusCode)
                
                // ❌ 401 НА AUTH — ВОЗВРАЩАЕМ ОШИБКУ
                if response.statusCode == 401, target.isAuthEndpoint {
                    completion(.failure(response.mapAPIError()))
                    return
                }
                
                // 🔄 401 НА ОБЫЧНЫХ ЗАПРОСАХ
                if response.statusCode == 401 {
                    print("""
                    🟠 UNAUTHORIZED (401)
                    🔵 [\(target.method.rawValue)] \(target.path)
                    """)
                    
                    self.enqueue {
                        self.request(target, completion: completion)
                    }
                    self.refreshIfNeeded()
                    return
                }
                
                // ✅ SUCCESS
                if (200...299).contains(response.statusCode) {
                    do {
                        print("📦 RESPONSE:", String(data: response.data, encoding: .utf8) ?? "NO JSON")
                        let decoded = try makeJSONDecoder().decode(T.self, from: response.data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    print("""
                       🔴 ERROR RESPONSE
                       🔵 [\(target.method.rawValue)] \(target.path)
                       📊 STATUS: \(response.statusCode)
                       📦 BODY: \(String(data: response.data, encoding: .utf8) ?? "NO JSON")
                       """)
                    
                    completion(.failure(response.mapAPIError()))
                }
                
            case .failure(let error):
                print("""
                🔴 NETWORK ERROR
                🔵 [\(target.method.rawValue)] \(target.path)
                ❗️ ERROR: \(error.localizedDescription)
                """)
                
                completion(.failure(error))
            }
        }
    }
    
    func requestWithoutDecoding(
        _ target: NetworkAPI,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                
                let statusCode = response.statusCode
                let body = String(data: response.data, encoding: .utf8) ?? "NO BODY"
                
                print("📊 STATUS:", statusCode)
                print("📦 BODY:", body)
                
                // ❌ 401 на auth
                if statusCode == 401, target.isAuthEndpoint {
                    completion(.failure(self.makeError(statusCode: statusCode, body: body)))
                    return
                }

                // 🔄 401 → refresh
                if statusCode == 401 {
                    self.enqueue {
                        self.requestWithoutDecoding(target, completion: completion)
                    }
                    self.refreshIfNeeded()
                    return
                }

                if (200...299).contains(statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(self.makeError(statusCode: statusCode, body: body)))
                }

            case .failure(let error):
                print("❌ NETWORK ERROR:", error)
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
                    let decoded = try? makeJSONDecoder().decode(RefreshResponse.self, from: response.data)
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
    
    private func makeJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
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
    
    private func makeError(statusCode: Int, body: String) -> NSError {
        return NSError(
            domain: "API_ERROR",
            code: statusCode,
            userInfo: [
                NSLocalizedDescriptionKey: "Status: \(statusCode)\n\(body)"
            ]
        )
    }
}

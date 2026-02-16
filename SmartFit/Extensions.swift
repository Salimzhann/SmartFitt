//
//  Extensions.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 07.02.2026.
//

import UIKit
import Moya
import Combine


extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}


extension Response {
    
    func mapAPIError() -> Error {
        do {
            let apiError = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            
            return NSError(
                domain: "NetworkError",
                code: statusCode,
                userInfo: [NSLocalizedDescriptionKey: apiError.detail.error]
            )
            
        } catch {
            return NSError(
                domain: "NetworkError",
                code: statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Unexpected server error"]
            )
        }
    }
}

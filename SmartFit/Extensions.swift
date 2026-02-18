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


extension UIColor {
    
    /// #9CBEFA
    static let softBlue = UIColor(
        red: 156/255,
        green: 190/255,
        blue: 250/255,
        alpha: 1
    )
    
    /// #FAC99C
    static let softOrange = UIColor(
        red: 250/255,
        green: 201/255,
        blue: 156/255,
        alpha: 1
    )
    
    /// #EEFFE3
    static let softGreenBackground = UIColor(
        red: 238/255,
        green: 255/255,
        blue: 227/255,
        alpha: 1
    )
    
    /// #BEE99F
    static let softGreen = UIColor(
        red: 190/255,
        green: 233/255,
        blue: 159/255,
        alpha: 1
    )
}

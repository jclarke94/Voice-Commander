//
//  AppolyAPI.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation
import PassportKit

public protocol AppolyAPI {

    // MARK: - Variables
    var url: URL { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var additionalHeaders: [String: String] { get }

}

extension AppolyAPI {
    var body: Data?{
        return nil
    }
    
    var additionalHeaders: [String: String]{
        return [:]
    }
    
    /// URL request used for all network traffic, if you need to add custom headers to every request then add them here.
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpBody = body
        if request.httpBody != nil {
            let version = "\(Configuration.version)(\(Configuration.buildNumber))"
            request.setValue("application/json", forHTTPHeaderField: "Encoding")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(version, forHTTPHeaderField: "App-Version")
            request.addValue("iOS", forHTTPHeaderField: "App-Platform")
        }
        if let bearer = PassportKit.shared.authToken {
            request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        additionalHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpMethod = method.rawValue
        return request
    }

}

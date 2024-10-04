//
//  PushAPI.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 06/09/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation

enum PushAPI: AppolyAPI {

    // MARK: - Cases
    case upload(token: String)
    case delete(device: Int)

    // MARK: - Variables
    var url: URL {
        switch self {
        case .upload:
            return Configuration.baseURL.appendingPathComponent("/api/devices")
        case .delete(let device):
            return Configuration.baseURL.appendingPathComponent("/api/devices/\(device)")
        }
    }

    var body: Data? {
        switch self {
        case .upload(let token):
            let json: [String: Any] = ["token": token, "type": 0]
            return try? JSONSerialization.data(withJSONObject: json)
        case .delete:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .upload:
            return .post
        case .delete:
            return .delete
        }
    }
}

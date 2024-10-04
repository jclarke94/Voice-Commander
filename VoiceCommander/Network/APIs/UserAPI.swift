//
//  UserAPI.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 08/03/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation
import UIKit

enum UserAPI: AppolyAPI {

    // MARK: - Cases
    case create(request: RegisterRequest, encoder: JSONEncoder = .init())
    case read
    case update(request: UserUpdateRequest, encoder: JSONEncoder = .init())
    case delete

    // MARK: - Variables
    var url: URL {
        switch self {
        case .create:
            return Configuration.baseURL.appendingPathComponent("/api/users")
        case .read, .update, .delete:
            return Configuration.baseURL.appendingPathComponent("/api/user")
        }
    }

    var body: Data? {
        switch self {
        case .create(let request, let encoder):
            return try? encoder.encode(request)
        case .update(let request, let encoder):
            return try? encoder.encode(request)
        case .read, .delete:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .read:
            return .get
        case .update:
            return .patch
        case .delete:
            return .delete
        }
    }
}

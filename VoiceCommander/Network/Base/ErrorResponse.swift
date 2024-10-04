//
//  ErrorResponse.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation

/// Response decodable that expects a structure like the following;
/// {
///    "success": false,
///    "message": "There has been an error",
/// }
internal struct ErrorResponse: Decodable {

    // MARK: - Variables
    let success: Bool
    let message: String

    // MARK: - Initializers
    enum CodingKeys: CodingKey {
        case success
        case message
    }

    // MARK: - Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.message = try container.decode(String.self, forKey: .message)
    }

}

//
//  UserUpdateRequest.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 10/03/2023.
//

import Foundation

struct UserUpdateRequest: Encodable {

    // MARK: - Variables
    let id: Int64
    let email: String?
    let password: String?
    
    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
        case passwordConfirmation = "confirm_password"
    }
    
    // MARK: - Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.password, forKey: .password)
        try container.encodeIfPresent(self.password, forKey: .passwordConfirmation)
    }
    
}

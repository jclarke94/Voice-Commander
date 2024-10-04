//
//  PushUploadRequest.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 11/03/2023.
//

import Foundation

struct PushUploadRequest: Codable {

    // MARK: - Variables
    let token: String
    let type: Int
    
    // MARK: - Intializers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
        self.type = 0
    }
    
}

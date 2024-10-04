//
//  PushService.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 06/09/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation

class PushService: AppolyNetworkService {

    // MARK: - Utilities
    
    /// Uploads a given device APNS token to the server
    /// - Parameter deviceToken: Device APNS token
    /// - Returns: A successful upload response, containing the ID of the token stored on the server
    func upload(deviceToken: String) async throws -> PushUploadResponse {
        let api: PushAPI = .upload(token: deviceToken)
        let response: ObjectResponse<PushUploadResponse> = try await request(api)
        return response.data
    }

    /// Deletes a push notification token from the server.
    /// - Parameter device: ID of the token stored on the server
    func delete(device: Int) async throws {
        let api: PushAPI = .delete(device: device)
        return try await request(api)
    }

}

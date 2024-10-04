//
//  UserService.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 08/03/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation
import CoreData
import PassportKit

class UserService: AppolyNetworkService {

    // MARK: - Actions
    /// Registers a user with given account details
    /// - Parameters:
    ///   - email: Email address used to authenticate the user
    ///   - password: Password used to authenticate the user
    func register(email: String, password: String) async throws {
        let api: UserAPI = .create(request: .init(email: email, password: password))
        return try await request(api)
    }
    
    /// Fetches a user from core data or via network request
    /// - Parameter refresh: Specifies if we re-fetch the user from the network
    /// - Returns: User object that's been saved to core data
    func get(refresh: Bool) async throws -> User {
        if refresh {
            let api: UserAPI = .read
            let response: ObjectResponse<UserResponse> = try await request(api)
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.main.async {
                    do {
                        let context = CoreDataService.shared.context
                        let user = User(response: response.data, insertInto: context)
                        try context.save()
                        continuation.resume(returning: user)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.main.async {
                    do {
                        guard let user: User = try CoreDataService.shared.fetchEntity() else {
                            PassportKit.shared.unauthenticate()
                            throw NetworkError.unauthenticated
                        }
                        continuation.resume(returning: user)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    /// Attempts to update a users email address on the server
    /// - Parameters:
    ///   - user: User object we wish to update
    ///   - email: Email address we wish to replace the user's current email with
    /// - Returns: User object that's been updated & saved to core data
    @discardableResult
    func update(user: User, withEmail email: String) async throws -> User {
        let api: UserAPI = .update(request: .init(id: user.id, email: email, password: nil))
        let response: ObjectResponse<UserResponse> = try await request(api)
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let context = CoreDataService.shared.context
                    guard let user: User = context.object(with: user.objectID) as? User else {
                        PassportKit.shared.unauthenticate()
                        throw NetworkError.unauthenticated
                    }
                    user.email = response.data.email
                    try context.save()
                    continuation.resume(returning: user)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Attempts to update a users email address on the server
    /// - Parameters:
    ///   - user: User object we wish to update
    ///   - password: Password we wish to replace the user's current password with
    /// - Returns: User object that's been updated & saved to core data
    @discardableResult
    func update(user: User, withPassword password: String) async throws -> User {
        let api: UserAPI = .update(request: .init(id: user.id, email: nil, password: password))
        try await request(api)
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let context = CoreDataService.shared.context
                    guard let user: User = context.object(with: user.objectID) as? User else {
                        PassportKit.shared.unauthenticate()
                        throw NetworkError.unauthenticated
                    }
                    continuation.resume(returning: user)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Deletes a user from the server, core data and then logs out
    func delete() async throws {
        let api: UserAPI = .delete
        
        // Delete user on server
        try await request(api)
        
        // Logs user out
        try await unauthenticate()
    }
    
    /// Logs out and removes data from core data
    func unauthenticate() async throws {
        let user = try await get(refresh: false)
        // Delete device token on server
        try await DeviceTokenManager.standard.deleteDevice()
        
        // Delete user from core data
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let context = CoreDataService.shared.context
                    context.delete(user)
                    try context.save()
                    PassportKit.shared.unauthenticate()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}

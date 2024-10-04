//
//  DeviceTokenManager.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 06/09/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation
import PassportKit
import UIKit

typealias BackgroundFetchCompletion = (UIBackgroundFetchResult) -> Void

class DeviceTokenManager {

    // MARK: - Enums
    enum DeviceTokenError: Error {
        case notAuthenticated
        case tokenAlreadyUploaded
        case tokenNotUploaded
        case noDeviceToken
        case noDeviceID
        case failedToGenerateURL
        case invalidResponse
        case unknown
    }

    // MARK: - Variables
    private let deviceTokenKey: String = "DEVICE_TOKEN"
    private let deviceTokenUploadedKey: String = "DEVICE_TOKEN_UPLOADED"
    private let deviceIDKey: String = "DEVICE_ID"
    private let service = PushService()
    private let passport = PassportKit.shared
    static let standard = DeviceTokenManager()

    private var uploadingToken: String?
    private var deviceToken: String? {
        get {
            return UserDefaults.standard.string(forKey: deviceTokenKey)
        } set {
            if newValue != deviceToken {
                deviceTokenUploaded = false
            }

            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: deviceTokenKey)
                return
            }

            UserDefaults.standard.set(value, forKey: deviceTokenKey)
        }
    }

    private(set) var deviceTokenUploaded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: deviceTokenUploadedKey)
        } set {
            UserDefaults.standard.set(newValue, forKey: deviceTokenUploadedKey)
        }
    }

    private(set) var deviceID: Int? {
        get {
            return UserDefaults.standard.integer(forKey: deviceIDKey)
        } set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: deviceIDKey)
                return
            }

            UserDefaults.standard.set(value, forKey: deviceIDKey)
        }
    }

    // MARK: - Initializers
    private init() { }

    // MARK: - Token Setup
    
    /// Sets the device token and uploads it to the server if necessary
    /// - Parameters:
    ///   - token: Token to be recorded and uploaded
    ///   - backgroundCompletion: Background fetch completion to be ran if upload has happened
    ///   while app is in the background
    func setDeviceToken(_ token: String, backgroundCompletion: BackgroundFetchCompletion? = nil) async {
        // If token provided doesn't match the one we recorded previously, attempt to upload it.
        guard token != self.deviceToken else {
            uploadIfNecessary(completion: backgroundCompletion)
            return
        }

        // If the device token recorded previously is not nil, delete the old one
        if deviceToken != nil {
            do {
                try await deleteDevice()
            } catch {
                backgroundCompletion?(.failed)
            }
        }

        // Record and upload token.
        self.deviceToken = token
        uploadIfNecessary(completion: backgroundCompletion)
    }

    // MARK: - Token Upload
    /// Uploads a push notification token If possible.
    /// - Parameter completion: Records a background fetch result if the function is called while
    /// the app is in the background
    func uploadIfNecessary(completion: ((UIBackgroundFetchResult) -> Void)?) {
        // Ensures we are authenticated, we have a device token and it has not been uploaded already
        guard deviceToken != nil, !deviceTokenUploaded, PassportKit.shared.isAuthenticated else {
            completion?(.noData)
            return
        }

        // Attempts upload
        Task {
            do {
                try await uploadDeviceToken()
                completion?(.newData)
            } catch {
                completion?(.failed)
            }
        }
    }

    private func uploadDeviceToken() async throws {
        // Ensures we have a token and it isn't already uploading, if not then throw an error
        guard let token = deviceToken else { throw DeviceTokenError.noDeviceToken }
        guard token != uploadingToken else { throw DeviceTokenError.tokenAlreadyUploaded }

        // Begin upload
        uploadingToken = token
        _ = try await service.upload(deviceToken: token)
    }

    // MARK: - Token Deletion
    
    /// Deletes the stored token
    func deleteDevice() async throws {
        guard deviceTokenUploaded else { throw DeviceTokenError.tokenNotUploaded }
        guard let deviceID = deviceID else { throw DeviceTokenError.noDeviceID }
        try await service.delete(device: deviceID)
    }

    // MARK: - Push Registration
    
    /// Requests notification authorization and registers for push notifications on success
    /// - Parameter options: Autorization options, specifies how we wish the user to be
    /// alerted on notification, defaults to `sound` & `banner`
    func requestPushAuthorisationAndRegister(options: UNAuthorizationOptions = [.sound, .alert],
                                             backgroundCompletion: BackgroundFetchCompletion? = nil) async throws {
        guard try await UNUserNotificationCenter.current().requestAuthorization(options: options) else { return }
        await MainActor.run {
            self.registerForPushNotifications()
        }
    }

    private func registerForPushNotifications(backgroundCompletion: BackgroundFetchCompletion? = nil) {
        // Register for push notifications if necessary
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                backgroundCompletion?(.noData)
                return
            }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

}

//
//  Configuration.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 24/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//

import Foundation
import PassportKit

// swiftlint: disable force_cast
// swiftlint: disable line_length
class Configuration {
    
    // MARK: - Defaults
    static var appFirstRun: Bool {
        get {
            if let value = UserDefaults.standard.value(forKey: "app_first_run") {
                return value as? Bool ?? true
            } else {
                return true
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "app_first_run")
        }
    }

    // MARK: - API
    static let clientSecret = Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_SECRET") as! String
    static let clientID = Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_ID") as! String
    static let baseURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "API_BASE") as! String)!
    static let environment = Environment(rawValue: Bundle.main.object(forInfoDictionaryKey: "ENVIRONMENT") as! String)!
    static let passport = PassportConfiguration(baseURL: baseURL, mode: .standard(clientID: clientID, clientSecret: clientSecret), keychainID: keychainID)
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    // MARK: - Sentry
    static let sentryDSN = Bundle.main.object(forInfoDictionaryKey: "SENTRY_DSN") as! String

    // MARK: - Keychain
    static let keychainID = String(format: "%@%@", Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String, Bundle.main.object(forInfoDictionaryKey: "ENVIRONMENT") as! String)

    // MARK: - Core Data
    static let encryptCoreData = Bundle.main.object(forInfoDictionaryKey: "ENCRYPT_CORE_DATA") as! String == "1"

}
// swiftlint: enable force_cast
// swiftlint: enable line_length

extension Configuration {

    enum Environment: String {
        case staging = "STAGING"
        case live = "LIVE"
    }

}

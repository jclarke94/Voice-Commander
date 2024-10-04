//
//  AppolyTemplateApp.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 17/02/2022.
//

import Sentry
import Valet
import PassportKit
import SwiftUI



@main
struct VoiceCommanderApp: App {

    // MARK: - Variables
    @StateObject private var passportKit = PassportKit.shared
    @UIApplicationDelegateAdaptor private var apnsManager: APNSManager
    
    

    // MARK: - Initializers
    init() {
        setupDependencies()
        if Configuration.appFirstRun {
            onFirstLaunch()
            Configuration.appFirstRun = false
        }
    }

    // MARK: - Views
    
    /// Specifies the view to be shown on initialization of the app, by default shows
    /// `MainView` if authenticated or `LoginView` if not
    var body: some Scene {
        WindowGroup {
            Group {
                
                ContainerView()
                    .transition(.move(edge: .bottom))
                
            }
            .animation(.default)
        }
    }

    // MARK: - Setup
    
    /// Code to be ran on first launch, clears keychain by default (logging the user out)
    private func onFirstLaunch() {
        // Clear keychain used by app and `PassportKit`
        guard let identifier = Identifier(nonEmpty: Configuration.keychainID) else { return }
        let keychain = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        keychain.removeAllObjects()
    }
    
    /// Code to be ran on app launch, used to specify any setup required by the app.
    private func setupDependencies() {
        _ = NetworkReachability.shared
        PassportKit.shared.setup(Configuration.passport)
        #if !DEBUG
            SentrySDK.start { options in
                options.dsn = Configuration.sentryDSN
                options.debug = true
            }
        #endif
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
    }

}

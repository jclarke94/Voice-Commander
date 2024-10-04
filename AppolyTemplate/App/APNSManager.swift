//
//  APNSManager.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import Foundation
import Firebase
import UIKit
import PassportKit
import UserNotifications

class APNSManager: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    // MARK: - Variables
    private var currentFetchCompletion: ((UIBackgroundFetchResult) -> Void)?

    // MARK: - Functionality

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard PassportKit.shared.isAuthenticated else { return }

        // As a backup to background mode
        DeviceTokenManager.standard.uploadIfNecessary(completion: nil)

        // Always register to check for a new token
        // Upload will happen in this case
        Task {
            do {
                try await DeviceTokenManager.standard.requestPushAuthorisationAndRegister()
            } catch {
                debugPrint(error.localizedDescription, type: .verbose)
            }
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        UNUserNotificationCenter.current().delegate = self
        Task {
            await DeviceTokenManager.standard.setDeviceToken(token, backgroundCompletion: self.currentFetchCompletion)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

        Messaging.messaging().token { [weak self] token, error in
            guard let self = self else { return }
            guard error == nil, let token = token else {
                self.currentFetchCompletion?(.failed)
                return
            }

            UNUserNotificationCenter.current().delegate = self
            Task {
                await DeviceTokenManager.standard
                    .setDeviceToken(token, backgroundCompletion: self.currentFetchCompletion)
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        currentFetchCompletion?(.failed)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.noData)
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        currentFetchCompletion = { (result) in
            self.currentFetchCompletion = nil
            completionHandler(result)
        }

        Task {
            do {
                try await DeviceTokenManager.standard
                    .requestPushAuthorisationAndRegister(backgroundCompletion: currentFetchCompletion)
            } catch {
                debugPrint(error.localizedDescription, type: .verbose)
            }
        }
    }
    
    /// Code to be ran when the app receives a notification or when the app is opened from a notification,
    /// empty by default - needs customizing per project specifications.
    /// - Parameters:
    ///   - center: Notification center instance that received the notification
    ///   - response: The notification response that was received
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {

    }
    
    /// Function that specifies how the app is to present notifications while the app is open
    /// - Parameters:
    ///   - center: Notification center instance that received the notification
    ///   - notification: The notification that was received
    /// - Returns: how we wish the user to be alerted on notification, defaults to `sound` & `banner`
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }

}

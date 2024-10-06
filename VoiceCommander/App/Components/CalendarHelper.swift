//
//  CalendarHelper.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI
import EventKit
import EventKitUI

class CalendarHelper: NSObject, EKEventEditViewDelegate {
    static let shared = CalendarHelper()
    
    private override init() {}
    
    func createEvent(title: String, startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                let eventController = EKEventEditViewController()
                eventController.event = event
                eventController.eventStore = eventStore
                eventController.editViewDelegate = self
                
                CalendarHelper.getRootViewController()?.present(eventController, animated: true, completion: nil)
            } else {
                print("Access to calendar not granted.")
            }
        }
    }

    
    static func getRootViewController() -> UIViewController? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        guard let firstWindow = firstScene.windows.first else { return nil }
        return firstWindow.rootViewController
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}


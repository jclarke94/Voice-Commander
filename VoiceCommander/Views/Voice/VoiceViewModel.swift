//
//  VoiceViewModel.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI
import Speech
import EventKit
import MessageUI

enum CommandKey: String {
    case Command
    case Details
}

enum Command : String {
    case none
    case calendar = "Calendar Command"
    case call = "Call Command"
    case whatsapp = "WhatsApp Command"
    case email = "Email Command"
}

enum CalendarInputter: String {
    case title = "What is this event called?"
    case startDate = "On what day does this event start?"
    case startTime = "At what time?"
    case endDate = "When will this event end?"
    case endTime = "At what time will it end?"
    case confirm = "Is this right?"
}

enum CallInputter: String {
    case contacts = "Do you want to call someone from your contacts? (contacts name or number)"
    case recipient = "Who do you want to call?"
    case confirm = "Is this right?"
}

enum WhatsAppInputter: String {
    case recipient = "Who do you want to WhatsApp message? (contacts name or number)"
    case contents = "What's the message?"
    case confirm = "Is this right?"
}

enum EmailInputter: String {
    case recipient = "What's the recipients email? (email address)"
    case subject = "What's the subject of the message?"
    case contents = "What's the contents of the email?"
    case confirm = "Is this right?"
}

class VoiceViewModel: VoiceCommanderVM {
    // MARK: - Variables
    @ObservedObject var cvm : ContainerViewModel
    
    @Published var totalHeard: String = ""
//    @Published var shortHeard: String = ""
    @Published var isListening: Bool = false
    @Published var activeCommand: Command = .none
    @Published var showSheet: Bool = false
    @Published var inputterMessage: String = ""
    
    @Published var showCalendar: Bool = false
    @Published var showCall: Bool = false
    @Published var showWhatsapp: Bool = false
    @Published var showEmail: Bool = false
    
    var commandDetails: [[String:String]] = []
    var addToHeard: Bool = true
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    
    
    
    // MARK: - Initializer
    init(_ cvm : ContainerViewModel) {
        self.cvm = cvm
    }
    
    func startListening() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
//            print("Speech recognition is not available.")
            return
        }
        
        // Stop and reset the audio engine if it's already running
        if audioEngine.isRunning {
            stopListening()
        }
        
        totalHeard = ""
        let request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        // Remove any existing taps to avoid 'Tap()' error
        inputNode.removeTap(onBus: 0)
        
        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                let command = result.bestTranscription.formattedString
                print("Heard command: \(command)")
                self.handleCommand(command)
                
            } else if let error = error {
//                print("Error recognizing speech: \(error.localizedDescription)")
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
//            print("Error starting audio engine: \(error.localizedDescription)")
        }
        
        self.isListening = isItListening()
        print("Started listening for commands.")
    }
    
    func stopListening() {
        recognitionTask?.cancel()
        recognitionTask = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // Remove the tap on the input node to clean up
        audioEngine.inputNode.removeTap(onBus: 0)
        
        isListening = isItListening()
        
        print("Stopped listening.")
    }
    
    // Check if the app is currently listening for commands
    func isItListening() -> Bool {
        return audioEngine.isRunning
    }
    
    // Handle recognized voice commands
    private func handleCommand(_ command: String) {
        // Process the command (e.g., create event, send message, etc.)
        print("Processing command: \(command)")
        
        if inputterMessage == CalendarInputter.startDate.rawValue ||
            inputterMessage == CalendarInputter.endDate.rawValue {
            totalHeard = extractDate(from: command)
        } else {
            totalHeard = command
        }
        
        
        
        if showSheet == false {
            if totalHeard.lowercased().contains("calendar") || totalHeard.lowercased().contains("schedule") || totalHeard.lowercased().contains("schedule") {
                
                showSheet(command: .calendar)
            } else if totalHeard.lowercased().contains("whatsapp") || totalHeard.lowercased().contains("message") {
                showSheet(command: .whatsapp)
            } else if totalHeard.lowercased().contains("call") || totalHeard.lowercased().contains("phone") || totalHeard.lowercased().contains("dial") {
                showSheet(command: .call)
            } else if totalHeard.lowercased().contains("email") {
                showSheet(command: .email)
            }
        } 
        
    }
    
    private func extractDate(from command: String) -> String {
           // Define possible date formats (e.g., "October 5, 2024", "5th October 2024")
           let dateFormats = ["MMMM d, yyyy", "d MMMM yyyy", "yyyy-MM-dd"]
           
           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale(identifier: "en_GB")
           
           for format in dateFormats {
               dateFormatter.dateFormat = format
               if let date = dateFormatter.date(from: command) {
                   return dateFormatter.string(from: date)
//                   return date
               }
           }
           
           // If no date was found, return nil
           return "No date given"
       }
       
       // Extract time from recognized string
       private func extractTime(from command: String) -> Date? {
           // Define time formats (e.g., "3:00 PM", "15:00")
           let timeFormats = ["h:mm a", "HH:mm"]
           
           let timeFormatter = DateFormatter()
           timeFormatter.locale = Locale(identifier: "en_US_POSIX")
           
           for format in timeFormats {
               timeFormatter.dateFormat = format
               if let time = timeFormatter.date(from: command) {
                   return time
               }
           }
           
           // If no time was found, return nil
           return nil
       }
    
    func hideSheet() {
        addToHeard = true
        showSheet = false
        clearHeard()
        activeCommand = .none
    }
    
    private func showSheet(command: Command) {
        startListening()
        clearCommandDetails()
        addToHeard = false
        switch command {
        case .none:
            self.showSheet = false
            totalHeard = ""
        case .calendar:
            self.activeCommand = .calendar
            startCommand()
            showSheet = true
        case .call:
            self.activeCommand = .call
            startCommand()
            showSheet = true
        case .whatsapp:
            self.activeCommand = .whatsapp
            startCommand()
            showSheet = true
        case .email:
            self.activeCommand = .email
            startCommand()
            showSheet = true
        }
    }
    
    func clearHeard() {
        startListening()
    }
    
    func clearCommandDetails() {
        commandDetails = []
    }
    
    func addCommandDetails(details: String) {
        commandDetails.append([CommandKey.Command.rawValue: inputterMessage, CommandKey.Details.rawValue : details])
        nextCommand()
    }
    
    func nextCommand() {
        startListening()
        switch activeCommand {
        case .none:
            print("shouldn't ever happen")
        case .calendar:
            if inputterMessage == CalendarInputter.title.rawValue {
                inputterMessage = CalendarInputter.confirm.rawValue
            } else if inputterMessage == CalendarInputter.startDate.rawValue {
                inputterMessage = CalendarInputter.startTime.rawValue
            } else if inputterMessage == CalendarInputter.startTime.rawValue {
                inputterMessage = CalendarInputter.endDate.rawValue
            } else if inputterMessage == CalendarInputter.endDate.rawValue {
                inputterMessage = CalendarInputter.endTime.rawValue
            } else if inputterMessage == CalendarInputter.endTime.rawValue {
                inputterMessage = CalendarInputter.confirm.rawValue
            } else if inputterMessage == CalendarInputter.confirm.rawValue {
                
                createCalendarEvent()
            }
        case .call:
            if inputterMessage == CallInputter.recipient.rawValue {
                inputterMessage = CallInputter.confirm.rawValue
            } else if inputterMessage == CallInputter.confirm.rawValue {
                startCall()
            }
        case .whatsapp:
            if inputterMessage == WhatsAppInputter.recipient.rawValue {
                inputterMessage = WhatsAppInputter.contents.rawValue
            } else if inputterMessage == WhatsAppInputter.contents.rawValue {
                inputterMessage = WhatsAppInputter.confirm.rawValue
            } else if inputterMessage == WhatsAppInputter.confirm.rawValue {
                createWhatsappMessage()
            }
        case .email:
            if inputterMessage == EmailInputter.recipient.rawValue {
                inputterMessage = EmailInputter.subject.rawValue
            } else if inputterMessage == EmailInputter.subject.rawValue {
                inputterMessage = EmailInputter.contents.rawValue
            } else if inputterMessage == EmailInputter.contents.rawValue {
                inputterMessage = EmailInputter.confirm.rawValue
            } else if inputterMessage == EmailInputter.confirm.rawValue {
                createEmail()
            }
        }
        
        getExistingDetails()
    }
    
    func createCalendarEvent() {
        startListening()
        print("create calendar event")
        hideSheet()
//        showCalendar = true
        
        var title = ""
        for commandDetail in commandDetails {
            if let command = commandDetail[CommandKey.Command.rawValue], let details = commandDetail[CommandKey.Details.rawValue] {
                if command == CalendarInputter.title.rawValue {
                    title = details
                }
            }
        }
        
        print("Calendar open title: \(title)")
//        let eventStore = EKEventStore()
//
//            eventStore.requestAccess(to: .event) { (granted, error) in
//            if granted {
//                let event = EKEvent(eventStore: eventStore)
//                event.title = title
//                event.startDate = Date()
//                event.endDate = Date()
//                event.calendar = eventStore.defaultCalendarForNewEvents
//                try? eventStore.save(event, span: .thisEvent)
//            } else {
//            print("not event store not granted")
//            }
        
        CalendarHelper.shared.createEvent(title: title, startDate: Date(), endDate: Date())
    }
    
    func startCall() {
        print("start call")
        
        startListening()
        hideSheet()
//        showCall = true
        
        var number = ""
        for commandDetail in commandDetails {
            if let command = commandDetail[CommandKey.Command.rawValue], let details = commandDetail[CommandKey.Details.rawValue] {
                if command == CallInputter.recipient.rawValue {
                    number = details
                }
            }
        }
        
        print("phone open number: \(number)")
        
        if let phoneURL = URL(string: "tel://\(number)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            } else {
                print("Error could not open")
            }
        } else {
            print("Error could not open phone")
        }
    }
    
    func createWhatsappMessage() {
        print("create whatsapp message")
        
        
        startListening()
        hideSheet()
//        showWhatsapp = true
        var number = ""
        var message = ""
        number.replacingOccurrences(of: " ", with: "")
        for commandDetail in commandDetails {
            if let command = commandDetail[CommandKey.Command.rawValue], let details = commandDetail[CommandKey.Details.rawValue] {
                if command == WhatsAppInputter.recipient.rawValue {
                    number = details
                } else if command == WhatsAppInputter.contents.rawValue {
                    message = details
                }
            }
        }
        
        print("whatsapp open number: \(number)")
        
        let urlString = "https://api.whatsapp.com/send?phone=\(number)&text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
    }
    
    func createEmail() {
       
        startListening()
        hideSheet()
//        showEmail = true
        print("create email")
        var recipient = ""
        var subject = ""
        var body = ""
        for commandDetail in commandDetails {
            if let command = commandDetail[CommandKey.Command.rawValue], let details = commandDetail[CommandKey.Details.rawValue] {
                if command == EmailInputter.recipient.rawValue {
                    recipient = details
                } else if command == EmailInputter.subject.rawValue {
                    subject = details
                } else if command == EmailInputter.contents.rawValue {
                    body = details
                }
            }
        }
        
        recipient.replacingOccurrences(of: " ", with: "")
        
        print("email open recipient: \(recipient)")
        
        MailHelper.shared.sendEmail(subject: subject, body: body, to: recipient)
    }
    
    func getExistingDetails() {
        for commandDetail in commandDetails {
            if let command = commandDetail[CommandKey.Command.rawValue], let details = commandDetail[CommandKey.Details.rawValue] {
                if command == inputterMessage {
                    totalHeard = details
                }
            }
        }
    }
    
    func isConfirmMessage() -> Bool {
        if inputterMessage == EmailInputter.confirm.rawValue ||
            inputterMessage == WhatsAppInputter.confirm.rawValue ||
            inputterMessage == CallInputter.confirm.rawValue ||
            inputterMessage == CalendarInputter.confirm.rawValue {
            return true
        } else {
            return false
        }
    }
    
    func commandDetailsFull() -> String {
        var out = ""
        for commandDetail in commandDetails {
            if let command = commandDetail[CommandKey.Command.rawValue], let details = commandDetail[CommandKey.Details.rawValue] {
                out = out + command + ": " + details + "\n\n"
            }
        }
        return out
    }
    
    func startCommand() {
        switch activeCommand {
        case .none:
            print("Shouldn't happen")
        case .calendar:
            inputterMessage = CalendarInputter.title.rawValue
        case .call:
            inputterMessage = CallInputter.recipient.rawValue
        case .whatsapp:
            inputterMessage = WhatsAppInputter.recipient.rawValue
        case .email:
            inputterMessage = EmailInputter.recipient.rawValue
        }
    }
}

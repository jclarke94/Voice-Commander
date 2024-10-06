//
//  VoiceView.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import SwiftUI
import EventKit
import MessageUI


struct VoiceView: View {
    
    @ObservedObject var viewModel: VoiceViewModel
    
    init (_ viewModel: VoiceViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                BackButtonHeader(title: "Voice View", action: {
                    viewModel.cvm.setViewState(viewState: .main)
                })
                
                Spacing(100)
                
                if viewModel.isListening {
                    Image.voice
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    Button {
                        viewModel.stopListening()
                    } label: {
                        PrimaryButton(text: "Stop Listening")
                    }.padding()
                } else {
                    Image.micOff
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    Button {
                        viewModel.startListening()
                    } label: {
                        PrimaryButton(text: "Start Listening")
                    }.padding()
                }
                
                
                Spacing(50)
                
                Text("What the apps heard so far:")
                    .font(.title2)
                
                if !viewModel.showSheet {
                    Text(viewModel.totalHeard)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                        .padding()
                } else {
                    Text(viewModel.activeCommand.rawValue)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                
                
                
                Spacer()
            }
            .sheet(isPresented: $viewModel.showSheet, onDismiss: {
                viewModel.hideSheet()
            }, content: {
                CommandSheet(viewModel)
            })
            .navigationDestination(isPresented: $viewModel.showCalendar, destination: {
                EmptyView().onAppear {
                    createCalendarEvent()
                }
            })
            .navigationDestination(isPresented: $viewModel.showCall, destination: {
                EmptyView().onAppear {
                    makePhoneCall()
                }
            })
            .navigationDestination(isPresented: $viewModel.showWhatsapp, destination: {
                EmptyView().onAppear {
                    sendWhatsAppMessage()
                }
            })
            .navigationDestination(isPresented: $viewModel.showEmail, destination: {
                EmptyView().onAppear {
                    sendEmail()
                }
            })
            
        }
        
    }
    
    func createCalendarEvent() {
        var title = ""
        for commandDetail in viewModel.commandDetails {
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
    
    func makePhoneCall() {
        var number = ""
        for commandDetail in viewModel.commandDetails {
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
    
    func sendWhatsAppMessage() {
        var number = ""
        var message = ""
        for commandDetail in viewModel.commandDetails {
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
    
    func sendEmail() {
        print("create email")
        var recipient = ""
        var subject = ""
        var body = ""
        for commandDetail in viewModel.commandDetails {
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
        
        print("email open recipient: \(recipient)")
        
        MailHelper.shared.sendEmail(subject: subject, body: body, to: recipient)
        
//        if MFMailComposeViewController.canSendMail() {
//                let mail = MFMailComposeViewController()
//                mail.setToRecipients([recipient])
//                mail.setSubject(subject)
//                mail.setMessageBody(body, isHTML: false)
//                present(mail, animated: true)
//            }
    }
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView(VoiceViewModel(ContainerViewModel()))
    }
}

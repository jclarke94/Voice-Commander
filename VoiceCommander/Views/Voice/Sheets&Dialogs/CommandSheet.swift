//
//  CalendarSheet.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI

struct CommandSheet: View {
    
    @ObservedObject var viewModel: VoiceViewModel
    
    init(_ viewModel: VoiceViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                HStack {
                    Button {
                    } label: {
                        Image.close
                            .resizable()
                            .frame(width: 20, height: 20)
                            .hidden()
                    }
                    Spacer()
                    
                    Image.voice
                        .resizable()
                        .frame(width:30, height: 30)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        viewModel.hideSheet()
                    } label: {
                        Image.close
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                }
                
                withAnimation {
                    Text(viewModel.activeCommand.rawValue)
                        .font(.title2)
                        .bold()
                        .underline()
                }
                
                
                Spacing(20)
                
                withAnimation {
                    Text(viewModel.inputterMessage)
                        .font(.title3)
                }
                
                    
                Spacer()
                
                HStack {
                    Text("Answer:")
                        .underline()
                    
                    Spacer()
                }
                
                HStack{
                    if viewModel.isConfirmMessage() {
                        withAnimation {
                            Text(viewModel.commandDetailsFull())
                                .foregroundColor(.red)
                        }
                        
                    } else {
                        withAnimation {
                            Text(viewModel.totalHeard)
                                .foregroundColor(.red)
                        }
                        
                    }
                    
                    
                    Spacer()
                }
                
                withAnimation {
                    Button {
                        viewModel.addCommandDetails(details: viewModel.totalHeard)
                    } label: {
                        PrimaryButton(text: "Confirm")
                    }
                }
                
                withAnimation {
                    Button {
                        if viewModel.isConfirmMessage() {
                            viewModel.clearHeard()
                        } else {
                            viewModel.startCommand()
                        }
                    } label: {
                        PrimaryButton(text: "Clear")
                    }
                }
                
                if !viewModel.isConfirmMessage() {
                    withAnimation {
                        Button {
                            viewModel.addCommandDetails(details: "")
                        } label: {
                            PrimaryButton(text: "Ignore")
                        }
                    }
                }
                
                Spacing(50)
            }
            .padding()
        }
    }
    
}

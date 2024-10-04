//
//  VoiceView.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import SwiftUI


struct VoiceView: View {
    
    @ObservedObject var viewModel: VoiceViewModel
    
    init (_ viewModel: VoiceViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                
                BackButtonHeader(title: "Voice View", action: {
                    viewModel.cvm.setViewState(viewState: .main)
                })
                
                
                
                Spacer()
            }
            
            
        }
        
    }
}

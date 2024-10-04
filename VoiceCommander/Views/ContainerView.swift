//
//  ContainerView.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import SwiftUI

struct ContainerView: View {
    
    @ObservedObject var viewModel = ContainerViewModel()
    
    var body: some View {
        switch viewModel.viewState {
        case .main:
            if let vm = viewModel.childViewModel as? MainViewModel {
                MainView(vm)
                    .transition(.move(edge: .bottom))
            }
        case .info:
            if let vm = viewModel.childViewModel as? AppInfoViewModel {
                AppInfoView(vm)
                    .transition(.move(edge: .trailing))
            }
            
        case .voice:
            if let vm = viewModel.childViewModel as? VoiceViewModel {
                VoiceView(vm)
                    .transition(.move(edge: .trailing))
            }
            
        }
    }
}

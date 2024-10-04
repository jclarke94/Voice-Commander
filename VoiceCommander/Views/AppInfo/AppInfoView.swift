//
//  AppInfoView.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import SwiftUI

struct AppInfoView: View {
    
    @ObservedObject var viewModel: AppInfoViewModel
    
    init (_ viewModel: AppInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            BackButtonHeader(title: "How Do?", action: {
                viewModel.cvm.setViewState(viewState: .main)
            })
            
            Spacing(50)
            
            Text("This is where I will explain how the app works and what you can do...")
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView(AppInfoViewModel(ContainerViewModel()))
    }
}

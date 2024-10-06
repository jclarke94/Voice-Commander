//
//  MainView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Variables
    @ObservedObject private var viewModel : MainViewModel
    
    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    

    // MARK: - View
    var body: some View {
        VStack(spacing: 10) {
            
            Spacing(80)
                
            Image.home
            .resizable()
            .frame(width: 50, height: 50)
                .foregroundColor(.black)
            
            Text("Voice Commander")
                .font(.title)
                .bold()
            
            Spacing(50)
            Button {
                //TODO: navigation
                viewModel.cvm.setViewState(viewState: .info)
            } label: {
                PrimaryButton(text: "What is this app?")
            }.padding()
            
            Spacing(50)
            
            Button {
                //TODO: navigation
                viewModel.cvm.setViewState(viewState: .voice)
            } label: {
                PrimaryButton(text: "Go to voice command!")
            }.padding()
            
            
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(MainViewModel(ContainerViewModel()))
    }
}

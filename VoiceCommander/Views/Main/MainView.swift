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
        VStack {
            
            
                
            Image.home
            .resizable()
            .frame(width: 32, height: 32)
                .foregroundColor(.black)
            
            Text("Voice Commander")
                .font(.title)
                .bold()
            
            Spacing(50)
            Button {
                //TODO: navigation
                viewModel.cvm.setViewState(viewState: .info)
            } label: {
                Text("What is this app?")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            
            Spacing(50)
            
            Button {
                //TODO: navigation
                viewModel.cvm.setViewState(viewState: .voice)
            } label: {
                Text("Go to voice command!")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            
            
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(MainViewModel(ContainerViewModel()))
    }
}

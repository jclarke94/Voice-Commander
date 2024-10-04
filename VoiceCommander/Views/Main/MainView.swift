//
//  MainView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import SwiftUI

struct MainView: View {
    // MARK: - Variables
    @ObservedObject private var viewModel = MainViewModel()

    // MARK: - View
    var body: some View {
        VStack {
            Text("Voice Commander")
                .font(.title)
                .bold()
            
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

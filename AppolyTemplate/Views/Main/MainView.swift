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
        switch viewModel.state {
        case .loaded:
            MainLoadedView(viewModel: viewModel)
            .transition(.opacity)
        case .loading:
            MainLoadingView()
            .transition(.opacity)
        case .error:
            MainErrorView(viewModel: viewModel)
            .transition(.opacity)
            }
        }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

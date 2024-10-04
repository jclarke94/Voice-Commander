//
//  LoginView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import SwiftUI
import PassportKit

struct LoginView: View {

    // MARK: - Variables
    @ObservedObject var viewModel = LoginViewModel(passwordRegex: ".{8,}")

    // MARK: - View
    var body: some View {
        switch viewModel.state {
        case .loading:
            LoginLoadingView()
                .transition(.opacity)
        case .loaded, .error:
            LoginLoadedView(viewModel: viewModel)
                .transition(.opacity)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

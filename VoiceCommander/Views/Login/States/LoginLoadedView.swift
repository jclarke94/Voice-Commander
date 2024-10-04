//
//  LoginLoadedView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import Foundation
import SwiftUI

struct LoginLoadedView: View {

    // MARK: - Variables
    @ObservedObject var viewModel = LoginViewModel(passwordRegex: ".{8,}")

    // MARK: - View
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 10) {
                HStack {
                    Text("Email")
                    Spacer()
                }
                TextField("Email", text: $viewModel.email)
                    .onChange(of: viewModel.email) { _ in
                        withAnimation {
                            viewModel.state = .loaded
                            viewModel.updateButton()
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            VStack(spacing: 10) {
                HStack {
                    Text("Password")
                    Spacer()
                }
                SecureField("Password", text: $viewModel.password)
                    .onChange(of: viewModel.password) { _ in
                        withAnimation {
                            viewModel.state = .loaded
                            viewModel.updateButton()
                        }
                    }
                .textFieldStyle(.roundedBorder)
                if case .error(let message) = viewModel.state {
                    HStack {
                        Text(message)
                            .foregroundColor(.red)
                            .font(.caption)
                        Spacer()
                    }
                }
            }

            Button("Login", action: viewModel.attemptLogin)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                .background(Color.accent)
                .opacity(viewModel.isValid ? 1 : 0.5)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }.padding(.all, 20)
    }

}

struct LoginLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        LoginLoadedView()
    }
}

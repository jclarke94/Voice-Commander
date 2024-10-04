//
//  MainErrorView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import SwiftUI

struct MainErrorView: View {
    // MARK: - Variables
    @ObservedObject var viewModel: MainViewModel

    // MARK: - View
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            if case .error(let message) = viewModel.state {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            Button("Logout", action: viewModel.logout)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                .background(Color.accent)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            Spacer()
        }.padding(.all, 20)
    }
}

struct MainErrorView_Previews: PreviewProvider {
    static var previews: some View {
        MainErrorView(viewModel: MainViewModel())
    }
}

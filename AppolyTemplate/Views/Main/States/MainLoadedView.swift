//
//  MainLoadedView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import SwiftUI

struct MainLoadedView: View {
    // MARK: - Variables
    @ObservedObject var viewModel: MainViewModel

    // MARK: - View
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            if let email = viewModel.user?.email {
                Text("Logged in as \(email)")
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

struct MainLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoadedView(viewModel: MainViewModel())
    }
}

//
//  MainLoadingView.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import Foundation
import SwiftUI

struct MainLoadingView: View {

    // MARK: - View
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                .scaleEffect(1.5)
            Spacer()
        }
    }
}

struct MainLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoadingView()
    }
}

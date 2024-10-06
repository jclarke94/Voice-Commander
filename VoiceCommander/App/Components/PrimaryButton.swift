//
//  MowPrimaryButton.swift
//  Mowtivated
//
//  Created by Joel Clarke on 23/07/2024.
//

import Foundation
import SwiftUI

struct PrimaryButton: View {
    
    //MARK: - Variables
    
    let text : String
    
    init(text: String) {
        self.text = text
    }
    
    //MARK: - View
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color.blue)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 0)
    }
}


struct MowPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "Button text here")
    }
}

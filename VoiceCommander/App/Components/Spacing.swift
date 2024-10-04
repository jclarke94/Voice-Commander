//
//  Spacer.swift
//  Mowtivated
//
//  Created by Joel Clarke on 03/10/2024.
//

import Foundation
import SwiftUI

struct Spacing: View {
    
    var space: CGFloat
    
    init(_ space: CGFloat = 8) {
        self.space = space
    }
    
    var body: some View {
        VStack{}.frame(height: space)
    }
}

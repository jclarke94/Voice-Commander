//
//  BackButtonHeader.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import SwiftUI

struct BackButtonHeader: View {
    
    var title: String
    var showBackButton = true
    var showCalendarDate = false
    var action: () -> Void
    var onCalendarDateTap: (() -> Void)?
    var tintColor: Color = Color.black
    
    //MARK: - initializers
    init(title: String, showBackButton: Bool = true, showCalendarDate: Bool = false, action: @escaping () -> Void, onCalendarDateTap: (() -> Void)? = nil, tintColor: Color) {
        self.title = title
        self.showBackButton = showBackButton
        self.showCalendarDate = showCalendarDate
        self.action = action
        self.onCalendarDateTap = onCalendarDateTap
        self.tintColor = tintColor
    }
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    init(title: String, tintColor: Color, action: @escaping () -> Void) {
        self.title = title
        self.tintColor = tintColor
        self.action = action
    }
    
    var body: some View {
        ZStack {
            
            HStack {
                if showBackButton {
                    Button {
                        action()
                    } label: {
                        VStack {
                            Image.back
                                .resizable()
                                .scaledToFit()
                                .padding(.all, 5)
                                .frame(width: 39, height: 35)
                                .foregroundColor(tintColor)
                        }
                    }
                } else {
                    Spacer()
                }
                
                
                Text(title)
                    .foregroundColor(tintColor)
                    .font(.title)
                    .bold()

                Spacer()
            }
            .padding(.horizontal, 9)
            .background(Color.clear)
        }
    }
}

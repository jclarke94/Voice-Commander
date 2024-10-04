//
//  Fonts.swift
//  Hear4U
//
//  Created by Sean Startin on 02/11/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation
import SwiftUI

enum Font {
    enum Inter {
        case black,
             bold,
             extraBold,
             extraLight,
             light,
             medium,
             regular,
             semiBold,
             thin

        var name: String {
            switch self {
            case .black:
                return "Black"
            case .bold:
                return "Bold"
            case .extraBold:
                return "ExtraBold"
            case .extraLight:
                return "ExtraLight"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .regular:
                return "Regular"
            case .semiBold:
                return "Semibold"
            case .thin:
                return "Thin"
            }
        }
    }

    case inter(Inter)

    var name: String {
        switch self {
        case .inter(let font):
            return "Inter-\(font.name)"
        }
    }
}

extension SwiftUI.Font {
    init(customFont: Font, size: CGFloat) {
        self.init(UIFont(name: customFont.name, size: size)!)
    }
}

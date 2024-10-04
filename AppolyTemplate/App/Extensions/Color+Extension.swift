//
//  Color+Extension.swift
//  AppolyTemplate
//
//  Created by Patryk Wegrzynski on 20/04/2023.
//

import SwiftUI

extension Color {
    private var uiColor: UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
    
    /**
     Returns a boolean value indicating whether the color luminosity
     of the Color object represented by the 'Color' property of the current object is light or dark.
     The 'isLight' property of the current object is set to true if the color luminosity indicates that
     the color is light, otherwise it is set to false.

     - Parameter self: The object whose 'Color' property represents the Color object to be evaluated for
     lightness or darkness.
     - Returns: A boolean value indicating whether the color luminosity of the Color object is light or dark.
     */
    var isLightColor: Bool {
        let uiColor: UIColor = self.uiColor
        let isLight: Bool = uiColor.isLight
        return isLight
    }
    
    // swiftlint:disable large_tuple
    private func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            alpha = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (red, green, blue, alpha)
    }
    // swiftlint:enable large_tuple
}

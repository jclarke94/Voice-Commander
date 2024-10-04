//
//  UIColor+Extension.swift
//  AppolyTemplate
//
//  Created by Patryk Wegrzynski on 20/04/2023.
//

import UIKit

extension UIColor {
    /**
     Returns a boolean value indicating whether the color luminosity of the UIColor object
     represented by the 'uiColor' property of the current object is light or dark.
     The 'isLight' property of the current object is set to true if the color luminosity
     indicates that the color is light, otherwise it is set to false.

     - Parameter self: The object whose 'uiColor' property represents the UIColor object
     to be evaluated for lightness or darkness.
     - Returns: A boolean value indicating whether the color luminosity of the UIColor object is light or dark.
     */
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.55
    }
}

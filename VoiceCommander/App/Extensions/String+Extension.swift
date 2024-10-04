//
//  String+Extension.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 07/03/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns the localized version of a string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}

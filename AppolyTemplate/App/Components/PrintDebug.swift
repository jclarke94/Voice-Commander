//
//  PrintDebug.swift
//  AppolyTemplate
//
//  Created by Ayrton Campbell-Barker on 17/06/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation
import UIKit

enum DebugPrintStyle: Int {
    
    // MARK: - Cases
    case generic = 0
    case verbose
}

/// Prints to terminal only when the app is debugging
/// - Parameters:
///   - message: Message to print to the terminal
///   - type: Printing style, generic or verbose
///   - file: The file that is printing to the terminal
///   - method: The method that is printing to the terminal
///   - line: The line that is printing to the terminal
func debugPrint(_ message: String,
                type: DebugPrintStyle,
                file: String = #file,
                method: String = #function,
                line: Int = #line) {
    #if DEBUG
    switch type {
    case .generic:
        print("\(file) \(method) line \(line)\n\(message)")
    case .verbose:
        print("\(file) \(method) line \(line)\n\(message)")
    }
    #endif
}

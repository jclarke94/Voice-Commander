//
//  MainViewModel.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import Foundation
import PassportKit
import SwiftUI

class MainViewModel: VoiceCommanderVM {

    // MARK: - Variables
    @ObservedObject var cvm : ContainerViewModel

    // MARK: - Initializer
    init(_ cvm : ContainerViewModel) {
        self.cvm = cvm
    }

    // MARK: - Functionality
    
    

}

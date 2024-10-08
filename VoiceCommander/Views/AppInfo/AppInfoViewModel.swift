//
//  AppInfoViewModel.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI

class AppInfoViewModel: VoiceCommanderVM {
    // MARK: - Variables
    @ObservedObject var cvm : ContainerViewModel

    // MARK: - Initializer
    init(_ cvm : ContainerViewModel) {
        self.cvm = cvm
    }
}

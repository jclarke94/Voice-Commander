//
//  VoiceCommanderVM.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI

protocol VoiceCommanderVM: ObservableObject {
    
    // MARK: - Variables
    var cvm: ContainerViewModel { get set }
}

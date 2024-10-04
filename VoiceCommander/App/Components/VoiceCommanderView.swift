//
//  VoiceCommanderView.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI

protocol VoiceCommanderView: View {
    
    var viewModel: any VoiceCommanderVM { get set }
}

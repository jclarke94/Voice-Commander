//
//  ContainerViewModel.swift
//  VoiceCommander
//
//  Created by Joel Clarke on 04/10/2024.
//

import Foundation
import SwiftUI

enum ViewState {
    case main
    case info
    case voice
}

class ContainerViewModel: ObservableObject {
    
    @Published var viewState: ViewState = .main
    @Published var childViewModel : Any?
    
    init() {
        setViewState(viewState: .main)
    }
    
    public func setViewState(viewState: ViewState) {
        DispatchQueue.main.async {
            self.attachChildVM(viewState: viewState)
            self.viewState = viewState
        }
    }
    
    public func attachChildVM(viewState: ViewState) {
        
        self.childViewModel = switch viewState {
        case .main:
            MainViewModel(self)
        case .info:
            AppInfoViewModel(self)
        case .voice:
            VoiceViewModel(self)
        default:
            nil
        }
    }
}

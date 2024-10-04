//
//  AppolyViewModel.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import SwiftUI

public enum UIState {
    
    // MARK: - Cases
    case loading
    case loaded
    case error(message: String)
}

protocol AppolyViewModel: ObservableObject {

    // MARK: - Variables
    var state: UIState { get set }

}

extension AppolyViewModel {
    
    // MARK: - Utilities
    
    /// Sets state of view
    /// - Parameter state: state of the view, loading, loaded or error
    /// - Parameter animated: whether or not to animate the change, defaults to true
    func setState(toState state: UIState, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            if animated {
                withAnimation {
                    self?.state = state
                }
            } else {
                self?.state = state
            }
        }
    }
    
    /// Asynchronously sets state of view
    /// - Parameter state: state of the view, loading, loaded or error
    /// - Parameter animated: whether or not to animate the change, defaults to true
    func setState(toState state: UIState, animated: Bool = true) async {
        await MainActor.run { [weak self] in
            withAnimation {
                if animated {
                    withAnimation {
                        self?.state = state
                    }
                } else {
                    self?.state = state
                }
            }
        }
    }
    
}

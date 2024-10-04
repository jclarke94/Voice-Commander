//
//  LoginViewModel.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import Foundation
import PassportKit
import SwiftUI

class LoginViewModel: PassportViewModel, AppolyViewModel {

    // MARK: - Variables
    @Published var isValid = false
    @Published var state: UIState = .loaded

    // MARK: - Initializers
    override init(passwordRegex: String? = nil) {
        super.init(passwordRegex: passwordRegex)
    }

    // MARK: - Functionality
    /// Attempts to validate and login with the user's given credentials
    func attemptLogin() {
        setState(toState: .loading)
        validateForLogin { [weak self] error in
            guard let self = self else { return }
            do {
                if let error = error { throw error }
                PassportKit.shared.authenticate(self) { [weak self] error in
                    if let error = error {
                        self?.setState(toState: .error(message: error.localizedDescription))
                        return
                    }
                    self?.setState(toState: .loaded)
                }
            } catch {
                self.setState(toState: .error(message: error.localizedDescription))
            }
        }
    }
    
    /// Updates the next button depending on whether input is valid or not
    func updateButton() {
        validateForLogin { error in
            withAnimation { [weak self] in
                guard let self = self else { return }
                self.isValid = error == nil
                self.state = .loaded
            }
        }
    }

}

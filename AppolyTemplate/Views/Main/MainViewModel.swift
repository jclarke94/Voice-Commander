//
//  MainViewModel.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 18/02/2022.
//

import Foundation
import PassportKit
import SwiftUI

class MainViewModel: AppolyViewModel, ObservableObject {

    // MARK: - Variables
    private let userService = UserService()
    @Published var state: UIState = .loading
    @Published var user: User?

    // MARK: - Initializer
    init() {
        refreshUser()
    }

    // MARK: - Functionality
    
    /// Refreshes the user object displayed on the view
    private func refreshUser() {
        setState(toState: .loading)
        Task { [weak self] in
            do {
                let user = try await self?.userService.get(refresh: true)
                await MainActor.run { [weak self] in
                    self?.user = user
                    self?.setState(toState: .loaded)
                }
            } catch {
                await self?.setState(toState: .error(message: error.localizedDescription))
            }
        }
    }
    
    /// Logs the user out
    func logout() {
        Task { [weak self] in
            do {
                try await self?.userService.unauthenticate()
            } catch {
                await self?.setState(toState: .error(message: error.localizedDescription))
            }
        }
    }

}

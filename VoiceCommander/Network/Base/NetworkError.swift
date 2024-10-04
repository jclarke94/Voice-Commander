//
//  NetworkError.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation

/// Generalized structure for network errors
internal struct NetworkError: LocalizedError {

    // MARK: - Static Errors
    
    /// Invalid response network error, used if decoding of a response fails or data is unexpectedly null
    static let invalidResponse: NetworkError = .init(
        code: nil,
        errorDescription: "NetworkError.InvalidResponse.Text".localized
    )
    
    /// Generic unknown network error, used as a last resort
    static let unknown: NetworkError = .init(
        code: nil,
        errorDescription: "NetworkError.Unknown.Text".localized
    )
    
    /// Network unavailable error, used when network reachability is `notReachable`
    static let networkUnavailable: NetworkError = .init(
        code: nil,
        errorDescription: "NetworkError.NetworkUnavailable.Text".localized
    )
    
    /// Unauthenticated error, used when the user is not authenticated
    static let unauthenticated: NetworkError = .init(
        code: 403,
        errorDescription: "NetworkError.Unauthenticated.Text".localized
    )

    // MARK: - Variables
    var code: Int?
    var errorDescription: String?

}

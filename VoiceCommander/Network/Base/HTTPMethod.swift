//
//  HTTPMethod.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation

/// HTTP statuses used to defin the method an `AppolyAPI` uses
public enum HTTPMethod: String {

    // MARK: - Cases
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"

}

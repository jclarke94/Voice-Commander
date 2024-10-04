//
//  AppolyNetworkInterceptor.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation

public struct AppolyNetworkInterceptor {
    
    /// Intercepts url request at the point of execution in order to transform it
    var intercept: (URLRequest) -> URLRequest

}

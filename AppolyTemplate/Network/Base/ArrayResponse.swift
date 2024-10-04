//
//  ArrayResponse.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation

/// Response decodable that expects a structure like the following;
/// {
///    "success": true,
///    "message": null,
///    "data": [<Insert Object>]
/// }
struct ArrayResponse<T: Decodable>: Decodable {

    // MARK: - Variables
    let data: [T]

}

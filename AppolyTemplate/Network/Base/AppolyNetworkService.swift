//
//  AppolyNetworkService.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 31/01/2023.
//

import Foundation
import PassportKit

public class AppolyNetworkService: NSObject {

    // MARK: - Variables
    private let decoder: JSONDecoder
    private let interceptor: AppolyNetworkInterceptor

    private lazy var session: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: URLSessionConfiguration.default)
    }()

    // MARK: - Initializers
    public init(decoder: JSONDecoder = .init(), interceptor: AppolyNetworkInterceptor? = nil) {
        self.decoder = decoder
        self.interceptor = interceptor ?? .init(intercept: { return $0 })
    }

    // MARK: - Utilities
    /// Makes a network request to a given api
    /// - Parameter api: API, used to specify al information used to make a HTTP request
    /// - Returns: Generic response type, must be decodable
    public func request<T: Decodable>(_ api: AppolyAPI) async throws -> T {
        guard NetworkReachability.shared.currentStatus == . satisfied else {
            throw NetworkError.networkUnavailable
        }
        return try await withCheckedThrowingContinuation { continuation in
            let request = interceptor.intercept(api.request)
            session.dataTask(with: request) { [weak self] data, response, error in
                do {
                    guard let self = self else { return }
                    guard error == nil else { throw error! }
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        throw NetworkError(code: nil, errorDescription: "Invalid Response Data")
                    }
                    switch response.statusCode {
                    case 401, 403:
                        PassportKit.shared.unauthenticate()
                        continuation.resume(throwing: NetworkError.unauthenticated)
                    case 400...499:
                        if let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) {
                            throw NetworkError(code: response.statusCode, errorDescription: errorResponse.message)
                        } else {
                            throw NetworkError.unknown
                        }
                    default:
                        continuation.resume(returning: try self.decoder.decode(T.self, from: data))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }

    /// Makes a network request to a given api
    /// - Parameter api: API, used to specify al information used to make a HTTP request
    public func request(_ api: AppolyAPI) async throws {
        guard NetworkReachability.shared.currentStatus == . satisfied else { throw NetworkError.networkUnavailable }
        return try await withCheckedThrowingContinuation { continuation in
            var request = interceptor.intercept(api.request)
            if let bearer = PassportKit.shared.authToken {
                request.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            }
            session.dataTask(with: request) { [weak self] data, response, error in
                do {
                    guard let self = self else { return }
                    guard error == nil else { throw error! }
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    switch response.statusCode {
                    case 401, 403:
                        PassportKit.shared.unauthenticate()
                        continuation.resume(throwing: NetworkError.unauthenticated)
                    case 400...499:
                        if let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) {
                            throw NetworkError(code: response.statusCode, errorDescription: errorResponse.message)
                        } else {
                            throw NetworkError.unknown
                        }
                    default:
                        continuation.resume(returning: ())
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }

}

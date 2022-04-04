//
//  DataFetcher.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import Foundation
import Combine

/// Types conforming to the `DataFetcher` protocol are expected to handle URL requests to return either data or an error.
public protocol DataFetcherProtocol {
    /// Perform a URL request without decoding the result and return a publisher.
    /// - Parameters:
    ///     - request: The request to perform.
    /// - Returns:
    ///     - AnyPublisher: The Publisher that can be subcribed to
    func perform(request: URLRequest) -> AnyPublisher<Data, DataFetcherError>

    /// Perform a URL request and decodes the result.
    /// - Parameters:
    ///     - request: The request to perform.
    ///     - object: The type of value to decode.
    /// - Returns:
    ///     - AnyPublisher: The Publisher that can be subcribed to
    func perform<T: Codable>(request: URLRequest, for object: T.Type) -> AnyPublisher<T, DataFetcherError>
}

/// An error that occurs during while `DataFetcher` is performing a request
public enum DataFetcherError: LocalizedError {
    /// Errors occuring in the network (tcp/http) layers:
    /// - Parameters:
    ///     - error: The underlying error.
    case networkError(Error)

    /// Errors occuring on the server and reported to us:
    /// - Parameters:
    ///     - description: A description of the error.
    case serverError(description: String, errorCode: Int)

    /// Errors related to the data we received, i.e. missing data
    /// or corrupted data
    /// - Parameters:
    ///     - description: A description of the error.
    case dataError(description: String)

    /// Errors related to parsing the data we received
    /// - Parameters:
    ///     - description: A description of the error.
    case parseError(description: String)

    /// Other errors:
    /// - Parameters:
    ///     - description: A description of the error.
    case genericError(description: String)

    /// Error used to indicate a request was cancelled. Upstream
    /// clients can use this to understand that this was not an actual
    /// error but a cancellation.
    case cancelled

    /// The description of the error
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .serverError(description: let description, errorCode: _):
            return description
        case .dataError(description: let description):
            return description
        case .parseError(description: let description):
            return description
        case .genericError(description: let description):
            return description
        case .cancelled:
            return ""
        }
    }
}

// MARK: - Default Data Fetcher for the app
final class DataFetcher: DataFetcherProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // For requests that don't require parsing
    func perform(request: URLRequest) -> AnyPublisher<Data, DataFetcherError> {
        session.dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw DataFetcherError.parseError(description: "Unable to parse response")
                }

                guard httpResponse.statusCode == 200 else {
                    throw DataFetcherError.serverError(description: "HTTP Error", errorCode: httpResponse.statusCode)
                }
                return data
            }
            .mapError { error in
                return .networkError(error)
            }
            .eraseToAnyPublisher()
    }

    // For requests that require parsing to a Codable
    func perform<T: Codable>(request: URLRequest, for object: T.Type) -> AnyPublisher<T, DataFetcherError> {
        perform(request: request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error in
                if type(of: error) == Swift.DecodingError.self {
                    print("JSON decoding error")
                    return .parseError(description: error.localizedDescription)
                }
                if let error = error as? DataFetcherError {
                    return error
                }
                return .genericError(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}


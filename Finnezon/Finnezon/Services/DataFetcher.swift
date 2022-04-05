//
//  DataFetcher.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import Foundation
import Combine

public protocol DataFetcherProtocol {
    func perform(request: URLRequest) -> AnyPublisher<Data, DataFetcherError>
    func perform<T: Codable>(request: URLRequest, for object: T.Type) -> AnyPublisher<T, DataFetcherError>
}

public enum DataFetcherError: LocalizedError {
    // Errors occuring in the network (tcp/http) layers
    case networkError(Error)
    // Errors occuring on the server and reported to us
    case serverError(description: String, errorCode: Int)
    // Errors related to the data we received, i.e. missing data
    case dataError(description: String)
    // Errors related to parsing the data we received
    case parseError(description: String)
    // Other errors:
    case genericError(description: String)

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


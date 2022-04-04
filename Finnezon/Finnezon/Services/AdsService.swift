//
//  AdsService.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import Combine
import Foundation

// MARK: - Public API for fetching ads
protocol AdsServiceProtocol {
    // MARK: - All categories and first page of courses
    func loadAllAds() -> AnyPublisher<[AdItem], AdsServiceError>
}

public enum AdsServiceError: LocalizedError {
    case dataFetcherError(DataFetcherError)
    case noAds

    public var errorDescription: String? {
        switch self {
        case .dataFetcherError(let error):
            return error.localizedDescription
        case .noAds:
            return ""
        }
    }
}

final class AdsService: AdsServiceProtocol {
    private let dataFetcher: DataFetcherProtocol

    init(dataFetcher: DataFetcherProtocol = DataFetcher()) {
        self.dataFetcher = dataFetcher
    }

    // MARK: - Ads API
    struct AdsAPI {
        static let scheme = "https"
        static let host = "gist.githubusercontent.com"
        static let path = "baldermork"
    }

    // MARK: - Images API
    struct ImagesAPI {
        static let scheme = "https"
        static let host = "images.finncdn.no"
        static let path = "dynamic/480x360c"
    }

    // MARK: - Endpoint
    enum Endpoint {
        case allAds
        case image(imageURL: String)

        func request() -> URLRequest {
            var components = URLComponents()

            switch self {
            case .allAds:
                components.scheme = AdsAPI.scheme
                components.host = AdsAPI.host
                components.path = AdsAPI.path + "/6a1bcc8f429dcdb8f9196e917e5138bd/raw/discover.json"
            case let .image(imageURL):
                components.scheme = ImagesAPI.scheme
                components.host = ImagesAPI.host
                components.path = ImagesAPI.path + imageURL
            }

            guard let url = components.url else {
                fatalError("API Implementation Error")
            }

            return URLRequest(url: url)
        }
    }

    // MARK: - Public API Methods
    func loadAllAds() -> AnyPublisher<[AdItem], AdsServiceError> {
        dataFetcher.perform(
            request: Endpoint.allAds.request(),
            for: AdItemsResponse.self
        )
            .tryMap { adItemsResponse in
                guard let adItems = adItemsResponse.items else { throw AdsServiceError.noAds }
                return adItems
            }
            .mapError { error in
                if let error = error as? DataFetcherError {
                    return AdsServiceError.dataFetcherError(error)
                } else if let error = error as? AdsServiceError {
                    return error
                }
                return AdsServiceError.dataFetcherError(.genericError(description: error.localizedDescription))
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - MockAdsService
final class MockAdsService: AdsServiceProtocol {
    // Retrieves ad items from the local JSON file for testing and preview purposes
    func loadAllAds() -> AnyPublisher<[AdItem], AdsServiceError> {
        let decoder = JSONDecoder()

        guard
            let localURL = Bundle.main.url(forResource: "ad-items-response", withExtension: "json"),
            let data = try? Data(contentsOf: localURL),
            let adItemsResponse = try? decoder.decode(AdItemsResponse.self, from: data),
            let adItems = adItemsResponse.items,
            adItems.isEmpty == false
        else {
            return Fail(error: AdsServiceError.noAds)
                .eraseToAnyPublisher()
        }

        return Just(adItems)
            .setFailureType(to: AdsServiceError.self)
            .eraseToAnyPublisher()
    }
}

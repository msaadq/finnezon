//
//  DependencyContainerProtocol.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import Foundation

protocol DependencyContainerProtocol {
    var adsService: AdsServiceProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    var adsService: AdsServiceProtocol

    init(dataFetcher: DataFetcher = DataFetcher()) {
        self.adsService = AdsService(dataFetcher: dataFetcher)
    }
}

final class PreviewDependencyContainer: DependencyContainerProtocol {
    var adsService: AdsServiceProtocol

    init() {
        self.adsService = MockAdsService()
    }
}

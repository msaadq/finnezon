//
//  AdItemViewModel.swift
//  Finnezon
//
//  Created by Saad Qureshi on 05/04/2022.
//

import Foundation

class AdItemViewModel: ObservableObject {
    private var adItem: AdItem
    private let dependencyContainer: DependencyContainerProtocol
    private let currencyFormatter: NumberFormatter

    init(adItem: AdItem, dependencyContainer: DependencyContainerProtocol) {
        self.adItem = adItem
        self.dependencyContainer = dependencyContainer

        self.currencyFormatter = NumberFormatter()
        self.currencyFormatter.numberStyle = .currency
    }

    var adTypeLabel: String {
        adItem.adType.rawValue
    }

    var priceLabel: String {
        if let price = adItem.price, let formattedCurrency = currencyFormatter.string(from: NSNumber(value: price.value)) {
            return formattedCurrency
        } else {
            return "Free"
        }
    }

    var titleLabel: String? {
        adItem.itemDescription
    }

    var LocationLabel: String? {
        adItem.location
    }

    var isFavourite: Bool {
        adItem.isFavourite
    }

    var photoURL: URL? {
        if let url = adItem.image?.url {
            return AdsService.Endpoint.image(imageURL: url).url()
        } else {
            return nil
        }
    }

    func toggleFavouriteStatus() {
        adItem.isFavourite = !adItem.isFavourite
        self.objectWillChange.send()
    }
}

//
//  AdItem.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import Foundation

// MARK: - Ad Item
struct AdItem: Codable, Identifiable {
    let id: String
    let adType: AdType
    let itemDescription: String?
    let location: String?
    let price: Price?
    let image: Image?
    let score: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case adType = "ad-type"
        case itemDescription = "description"
        case location, price, image, score
    }

    enum AdType: String, Codable {
        case b2B = "B2B"
        case bap = "BAP"
        case car = "CAR"
        case cms = "CMS"
        case job = "JOB"
        case mc = "MC"
        case realestate = "REALESTATE"
    }

    // MARK: - Image
    struct Image: Codable {
        let url: String
        let type: ImageType
    }

    // MARK: - ImageType
    enum ImageType: String, Codable {
        case external = "EXTERNAL"
        case general = "GENERAL"
        case logo = "LOGO"
    }

    // MARK: - Price
    struct Price: Codable {
        let value: Int
        let total: Int?
    }
}

// MARK: - Ad Items Response
struct AdItemsResponse: Codable {
    let items: [AdItem]?
}

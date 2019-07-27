//
//  Restaurant .swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation

struct RestaurantModel: Codable {
    
    let businesses: [Business]?
}

struct Business: Codable {
    let id: String
    let alias: String?
    let name: String
    let image_url: String?
    let is_closed: Bool = true
    let url: String?
    let review_count: Int?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Coordinates?
    let transactions: [String]?
    let price: String?
    let location: Location?
    let phone: String?
    let display_phone: String?
    let distance: Double?
}

struct Category: Codable {
    let alias: String?
    let title: String?
}

struct Coordinates: Codable {
    let latitude: Double?
    let longitude: Double?
}

struct Location: Codable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let zip_code: String?
    let country: String?
    let state: String?
    let display_address: [String]?
}

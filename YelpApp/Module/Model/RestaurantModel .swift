//
//  Restaurant .swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation

class RestaurantModel  {
    
    var businesses: [Business]?
    
    class Business {
        var id: String?
        var alias: String?
        var name: String?
        var image_url: String?
        var is_closed: Bool = true
        var url: String?
        var review_count: Int?
        var categories: [Category]?
        var rating: Float?
        var coordinates: Coordinates?
        var transactions: [String]?
        var price: String?
        var location: Location?
        var phone: String?
        var display_phone: String?
        var distance: Float?
        
        class Category {
            var alias: String?
            var title: String?
        }
        
        class Coordinates{
            var latitude: String?
            var longitude: String?
        }
        
        class Location{
            var address1: String?
            var address2: String?
            var address3: String?
            var city: String?
            var zip_code: String?
            var country: String?
            var state: String?
            var display_address: [String]?
        }
    }
}

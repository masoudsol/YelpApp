//
//  ViewModel.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation


class ViewModel {
    typealias Restaurant = (name: String?, address: String?, rating: String?, distance: String?, type: String?, imageUrl: String?)
    
    static let shared = ViewModel()
    
    var reloadTable: ()->() = { }
    var reviewLoaded: ()->() = { }
    var restaurantModel = RestaurantModel(businesses: [])
    var reviewModel = ReviewModel(reviews: [])
    
    private var services = APIService()
    var selectedResto: Int?
    private init(){}
    
    func fetchRestaurants(lat: String, long: String){
        services.fetchRestaurant(lat: lat, long: long) { (result, error) in
            if let result = result as? RestaurantModel {
                self.restaurantModel = result
                self.reloadTable()
            }
        }
    }
    
    func getBusinuess(at index: Int) -> Restaurant {
        
        guard let business = restaurantModel.businesses?[index] else {
            return ("", "", "", "", "", "")
        }
        let ratingString = String(format: "%f%@%d", business.rating ?? "N/A", " stars from " , business.review_count ?? 0)
        let distance = String(format: "%@%f%@", "Distance ", business.distance ?? "N/A", "km")
        var categoriesText = ""
        if let categories = business.categories  {
            categories.forEach { (category) in
                categoriesText += category.title ?? ""
            }
        }
        
        return (business.name, business.location?.address1, ratingString, distance, categoriesText, business.image_url)
    }
    
    func fetchReview(at index: Int) {
        selectedResto = index
        guard let business = restaurantModel.businesses?[index] else {
            return
        }
        services.fetchRestaurantReview(businuessID: business.id) { (result, error) in
            if let result = result as? ReviewModel {
                self.reviewModel = result
                self.reviewLoaded()
            }
        }
    }
    
    func getReview() -> String {
        let review = reviewModel.reviews?[0]
        
        return String(format: "%dStars by %@: %@", review?.rating ?? 0,review?.user?.name ?? "N/A",review?.text ?? "N/A")
    }
}

//
//  ViewModel.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation


class ViewModel {
    typealias Restaurant = (name: String?, address: String?, rating: Double?, reviewCount: Int?, distance: String?, type: String?, imageUrl: String?, open: String, phone: String?, deliveryMethod: String?, price: String?, completeAddress: String?, restoID: String)
    
    static let shared = ViewModel()
    
    var reloadTable: ()->() = { }
    var reviewLoaded: ()->() = { }
    var restaurantModel = [Business]()
    var reviewModel = ReviewModel(reviews: [])
    var selectedResto: Int = 0
    
    private var services = APIService()
    private var ascendingOrder = false
    private init(){}
    
    func fetchRestaurants(keyword: String?, lat: String, long: String){
        services.fetchRestaurant(keyword: keyword, lat: lat, long: long) { (result, error) in
            if let result = result as? RestaurantModel, let businuesses = result.businesses {
                self.restaurantModel = businuesses
                self.reloadTable()
            }
        }
    }
    
    func getBusinuess(at index: Int) -> Restaurant {
        let business = restaurantModel[index]
        var distanceKM: String
        if let distance = business.distance{
            distanceKM = String(format: "Distance %.2fkm from you", distance/1000)
        } else {
            distanceKM = "Distance N/A"
        }
        
        var categoriesText = ""
        if let categories = business.categories {
            categories.forEach {
                categoriesText += $0.title ?? ""
                categoriesText += "-"
            }
            if categories.count > 0 {
                categoriesText.removeLast()
            }
        }
        
        var deliverText = ""
        if let transactions = business.transactions {
            transactions.forEach {
                deliverText += $0
                deliverText += "-"
            }
            if transactions.count > 0 {
                deliverText.removeLast()
            }
        }
        
        var completeAddress = ""
        if let displayAddress = business.location?.display_address {
            displayAddress.forEach {
                completeAddress += $0
                completeAddress += " "
            }
            
            if displayAddress.count > 0 {
                completeAddress.removeLast()
            }
        }
        
        return (business.name, business.location?.address1, business.rating, business.review_count, distanceKM, categoriesText, business.image_url, business.is_closed ? "Closed":"Open", business.phone, deliverText, business.price, completeAddress, business.id)
    }
    
    func fetchReview(at index: Int) {
        selectedResto = index
        let business = restaurantModel[index]
        services.fetchRestaurantReview(businuessID: business.id) { (result, error) in
            if let result = result as? ReviewModel {
                self.reviewModel = result
                self.reviewLoaded()
            }
        }
    }
    
    func getReview() -> String? {
        let review = reviewModel.reviews?[0]
        
        guard let name = review?.user?.name, let text = review?.text, let rating = review?.rating else {
            return nil
        }
        return String(format: "%.0f Stars by %@\n%@", rating, name, text)
    }
    
    func fetchAutoComplete(keyword: String, lat: String, long: String){
        
    }
    
    func sort(){
        ascendingOrder = !ascendingOrder
        
        restaurantModel = restaurantModel.sorted {
            if ascendingOrder{
                return $0.name < $1.name
            } else {
                return $0.name > $1.name
            }
        }
        
        reloadTable()
    }
}

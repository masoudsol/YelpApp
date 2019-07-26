//
//  APIService.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation

struct WebServiceConstants {
    static let baseURL = "https://api.yelp.com/v3"
    static let businuesSearchAPI = "/businesses/search"
    static let reviewsAPI = "/businesses/{id}/reviews"
    static let kAPIKEY = "Bearer iO2PJJCcnQY_WAq8PkD0jA70ErLPueb6vKxtSAitf64pEf2D48IG8PlN63kg33OmRF0hrwgLzBUwanilm7j4ilTZHfsi_UGEQsKP4fFhAa418KSijPgctrZhLzycW3Yx"
}

class APIService {
    typealias WebServiceCompletionBlock = (_ data: AnyObject?,_ error: Error?)->Void
    
    func fetchRestaurant(lat: String, long: String, complete: @escaping WebServiceCompletionBlock) {
        let url = WebServiceConstants.baseURL + WebServiceConstants.businuesSearchAPI + "?latitude=" + lat + "&longitude=" + long
        requestAPI(url: url, completion: complete)
    }
    
    func fetchRestaurantReview(businuessID: String, complete: @escaping WebServiceCompletionBlock) {
        var url = WebServiceConstants.baseURL + WebServiceConstants.reviewsAPI
        url = url.replacingOccurrences(of: "{id}", with: businuessID)
        
        requestAPI(url: url, completion: complete)
    }
    
    func requestAPI(url: String, completion: @escaping WebServiceCompletionBlock) {
        
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        var request = URLRequest(url: URL(string: escapedAddress)!)
        request.addValue(WebServiceConstants.kAPIKEY, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {                                                                 return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("Error in fetching response")
            }
            
            do {
                let decoder = JSONDecoder()
                let restaurantModel = try decoder.decode(RestaurantModel.self, from: data)
                completion(restaurantModel as AnyObject,error)
            } catch let error {
                print(error.localizedDescription)
                completion(nil,error)
            }
            
        }
        task.resume()
        
    }
}

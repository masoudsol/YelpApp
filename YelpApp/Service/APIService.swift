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
    static let businuesSearchAPI = "/businesses/search?categories=restaurants&limit=10"
    static let reviewsAPI = "/businesses/{id}/reviews"
    static let autocompleteAPI = "/autocomplete"
    static let kAPIKEY = "Bearer iO2PJJCcnQY_WAq8PkD0jA70ErLPueb6vKxtSAitf64pEf2D48IG8PlN63kg33OmRF0hrwgLzBUwanilm7j4ilTZHfsi_UGEQsKP4fFhAa418KSijPgctrZhLzycW3Yx"
}

class APIService {
    typealias WebServiceCompletionBlock = (_ data: Data?,_ error: Error?)->Void
    typealias ParsedCompletionBlock = (_ data: AnyObject?,_ error: Error?)->Void
    
    func fetchRestaurant(keyword: String?, lat: String, long: String, complete: @escaping ParsedCompletionBlock) {
        var url = WebServiceConstants.baseURL + WebServiceConstants.businuesSearchAPI
        if let keyword = keyword {
            url += "&term=" + keyword
        }
        url += "&latitude=" + lat + "&longitude=" + long
        requestAPI(url: url){ (data, error) in
            guard let data = data else{
                complete(nil,error)
                return
            }
            
            do {
                let parsedJson = try self.parseJson(RestaurantModel.self, from: data)
                complete(parsedJson as AnyObject,error)
            } catch let error {
                print(error.localizedDescription)
                complete(nil,error)
            }
        }
    }
    
    func fetchRestaurantReview(businuessID: String, complete: @escaping ParsedCompletionBlock) {
        var url = WebServiceConstants.baseURL + WebServiceConstants.reviewsAPI
        url = url.replacingOccurrences(of: "{id}", with: businuessID)
        
        requestAPI(url: url){ (data, error) in
            guard let data = data else{
                complete(nil,error)
                return
            }
            
            do {
                let parsedJson = try self.parseJson(ReviewModel.self, from: data)
                complete(parsedJson as AnyObject,error)
            } catch let error {
                print(error.localizedDescription)
                complete(nil,error)
            }
        }
    }
    
    func fetchAutoComplete(keyword: String, lat: String, long: String, complete: @escaping ParsedCompletionBlock) {
        let url = WebServiceConstants.baseURL + WebServiceConstants.autocompleteAPI + "?text=" + keyword + "&latitude=" + lat + "&longitude=" + long
        requestAPI(url: url){ (data, error) in
            guard let data = data else{
                complete(nil,error)
                return
            }
            
            do {
                let parsedJson = try self.parseJson(AutoCompleteModel.self, from: data)
                complete(parsedJson as AnyObject,error)
            } catch let error {
                print(error.localizedDescription)
                complete(nil,error)
            }
        }
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
                completion(nil, error)
            }
            
            completion(data,error)
            
        }
        task.resume()
        
    }
    
    func parseJson<T>(_ type: T.Type, from data: Data)  throws -> T? where T : Decodable {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(type.self, from: data)
            return model
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

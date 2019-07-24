//
//  APIService.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation

class APIService {
    func fetchRestaurants( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: Error? )->() ) {
        DispatchQueue.global().async {
            
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photos = try! decoder.decode(Photos.self, from: data)
            complete( true, photos.photos, nil )
        }
    }
    
    
    
}

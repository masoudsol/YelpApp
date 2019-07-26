//
//  ReviewModel.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-26.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation

struct ReviewModel: Codable {
    
    let reviews: [Review]?
}

struct Review: Codable  {
    let id: String
    let rating: Double?
    let user: User?
    let text: String?
}

struct User: Codable {
    let id: String
    let name: String
}

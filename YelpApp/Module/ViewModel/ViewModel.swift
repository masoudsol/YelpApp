//
//  ViewModel.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import Foundation

class ViewModel {
    
    var reloadTable: ()->() = { }
    
    
    func fetchRestaurants(){
        reloadTable()
    }
}

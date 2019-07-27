//
//  RestaurantCell.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-25.
//  Copyright © 2019 Mas One. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
}

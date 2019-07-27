//
//  ScrollViewController.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-26.
//  Copyright © 2019 Mas One. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    let viewModel = ViewModel.shared
    
    override func viewDidLoad() {
        viewModel.reviewLoaded = {[weak self] in
            DispatchQueue.main.async {
                self?.loadReview()
            }
        }
        
        let resto = viewModel.getBusinuess(at: viewModel.selectedResto ?? 0)
        
        nameLabel.text = resto.name
        addressLabel.text = resto.completeAddress
        distanceLabel.text = resto.distance
        typeLabel.text = resto.type
        openLabel.text = resto.open
        deliveryMethodLabel.text = resto.deliveryMethod
        phoneLabel.text = resto.phone
        if let rating = resto.rating, let reviewCount = resto.reviewCount{
            let rating = NSMutableAttributedString(string: String(rating), attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange])
            rating.append(NSAttributedString(string: " stars from "))
            rating.append(NSAttributedString(string: String(reviewCount), attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange]))
            rating.append(NSAttributedString(string: " reviews"))
            ratingLabel.attributedText = rating
        }
        
        if let price = resto.price, let type = resto.type {
            let attributedPrice = NSMutableAttributedString(string: price, attributes: [NSAttributedString.Key.foregroundColor : UIColor.brown])
            attributedPrice.append(NSAttributedString(string: " "+type))
            typeLabel.attributedText = attributedPrice
        } else {
            typeLabel.text = resto.type
        }
        
        guard let imageUrl = resto.imageUrl, let url = URL(string: imageUrl) else {
            return
        }
        imageView.pin_updateWithProgress = true
        imageView.pin_setImage(from: url)
        
    }
    
    private func loadReview(){
        reviewLabel.text = viewModel.getReview()
    }
}

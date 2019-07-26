//
//  DetailViewController.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-26.
//  Copyright © 2019 Mas One. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var deliveryMethod: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var review: UILabel!
    
    let viewModel = ViewModel.shared
   
    override func viewDidLoad() {
        viewModel.reviewLoaded = {[weak self] in
            DispatchQueue.main.async {
                self?.loadReview()
            }
        }
        
        let resto = viewModel.getBusinuess(at: viewModel.selectedResto ?? 0)
        
        name.text = resto.name
        address.text = resto.address
        rating.text = resto.rating
        distance.text = resto.distance
        type.text = resto.type
        open.text = resto.open
        deliveryMethod.text = resto.deliveryMethod
        phoneNumber.text = resto.phone
        guard let imageUrl = resto.imageUrl, let url = URL(string: imageUrl) else {
            return
        }
        imageView.pin_updateWithProgress = true
        imageView.pin_setImage(from: url)
        
    }
    
    private func loadReview(){
        review.text = viewModel.getReview()
    }
}

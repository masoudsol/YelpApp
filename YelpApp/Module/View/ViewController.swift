//
//  ViewController.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-24.
//  Copyright © 2019 Mas One. All rights reserved.
//

import UIKit
import CoreLocation
import PINRemoteImage

class ViewController: UICollectionViewController {
    
    private let viewModel = ViewModel.shared
    private let loading = UIActivityIndicatorView(style: .whiteLarge)
    private var locationManager: CLLocationManager?
    lazy private var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Your placeholder"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        loading.startAnimating()
        // Do any additional setup after loading the view.
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.loading.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
}

//Data Source
extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as? RestaurantCell else {
            return UICollectionViewCell()
        }
        let resto = viewModel.getBusinuess(at: indexPath.item)
        
        restaurantCell.name.text = resto.name
        restaurantCell.address.text = resto.address
        restaurantCell.rating.text = resto.rating
        restaurantCell.distance.text = resto.distance
        guard let imageUrl = resto.imageUrl, let url = URL(string: imageUrl) else {
            return restaurantCell
        }
        restaurantCell.imageView.pin_updateWithProgress = true
        restaurantCell.imageView.pin_setImage(from: url)
        
        return restaurantCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.restaurantModel.businesses?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.fetchReview(at: indexPath.item)
    }
}

//Location Manager Delegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
             print("Location permission denied")
             print("Fetching Restaurants in Toronto")
            viewModel.fetchRestaurants(lat: "43.6532", long: "79.3832")
        case .authorizedWhenInUse:
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("Got Location")
            print("Fetching Restaurants")
            viewModel.fetchRestaurants(lat: String(locValue.latitude), long: String(locValue.longitude))
        default:
            break
        }
    }
}


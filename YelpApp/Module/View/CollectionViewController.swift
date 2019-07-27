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

class CollectionViewController: UICollectionViewController {
    
    private let viewModel = ViewModel.shared
    private let loading = UIActivityIndicatorView(style: .whiteLarge)
    private var locationManager: CLLocationManager?
    lazy private var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-150, height: 20))
    private var autocompleteTableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search a Business"
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort(A-z)", style: .plain, target: self, action: #selector(sortTapped))
        
        autocompleteTableView =  UITableView(frame: CGRect(x: 0, y: 80, width: 320, height: 120),style: UITableView.Style.plain)
        autocompleteTableView.delegate = self;
        autocompleteTableView.dataSource = self;
        autocompleteTableView.isScrollEnabled = true;
        autocompleteTableView.isHidden = true;
        searchBar.addSubview(autocompleteTableView)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc func sortTapped(){
        viewModel.sort()
    }
}

//Data Source
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as? RestaurantCell else {
            return UICollectionViewCell()
        }
        let resto = viewModel.getBusinuess(at: indexPath.item)
        
        restaurantCell.favouriteImageView.isHidden = !UserDefaults.standard.bool(forKey: resto.restoID)
        restaurantCell.name.text = resto.name
        restaurantCell.address.text = resto.address
        restaurantCell.distance.text = resto.distance
        restaurantCell.layer.borderColor = UIColor.lightGray.cgColor
        
        if let rating = resto.rating, let reviewCount = resto.reviewCount{
            let rating = NSMutableAttributedString(string: String(rating), attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange])
            rating.append(NSAttributedString(string: " stars from "))
            rating.append(NSAttributedString(string: String(reviewCount), attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange]))
            rating.append(NSAttributedString(string: " reviews"))
            restaurantCell.rating.attributedText = rating
        }
        
        if let price = resto.price, let type = resto.type {
            let attributedPrice = NSMutableAttributedString(string: price, attributes: [NSAttributedString.Key.foregroundColor : UIColor.brown])
            attributedPrice.append(NSAttributedString(string: " "+type))
            restaurantCell.type.attributedText = attributedPrice
        } else {
            restaurantCell.type.text = resto.type
        }
        
        guard let imageUrl = resto.imageUrl, let url = URL(string: imageUrl) else {
            return restaurantCell
        }
        restaurantCell.imageView.pin_updateWithProgress = true
        restaurantCell.imageView.pin_setImage(from: url)
        
        return restaurantCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.restaurantModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.fetchReview(at: indexPath.item)
    }
}

//Location Manager Delegate
extension CollectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
             print("Location permission denied")
             print("Fetching Restaurants in Toronto")
             viewModel.fetchRestaurants(keyword: nil, lat: "43.6532", long: "79.3832")
        case .authorizedWhenInUse:
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("Got Location")
            print("Fetching Restaurants")
            viewModel.fetchRestaurants(keyword: nil, lat: String(locValue.latitude), long: String(locValue.longitude))
        default:
            break
        }
    }
}

//Search Bar Delegate
extension CollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locValue: CLLocationCoordinate2D = locationManager?.location?.coordinate {
            viewModel.fetchRestaurants(keyword: searchBar.text, lat: String(locValue.latitude), long:  String(locValue.longitude))
        } else {
            //Default to Toronto
            viewModel.fetchRestaurants(keyword: searchBar.text, lat: "43.6532", long: "79.3832")
        }
        searchBar.endEditing(true)
        
        return
    }
}

//Autocomplete TableView Delegate
extension CollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//Autocomplete TableView DataSource
extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

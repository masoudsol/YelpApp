//
//  FavouriteCollectionViewController.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-28.
//  Copyright © 2019 Mas One. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {
    
    let viewModel = ViewModel.shared

    override func viewDidLoad() {
        title = "Favourite"
        
        viewModel.loadFavourites()
        
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        tableView.allowsSelection = false
    }
    
}

extension FavouriteTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.getFav(at: indexPath.row)
        cell.imageView?.image = UIImage(named: "Star_On")
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favNames?.count ?? 0
    }
}

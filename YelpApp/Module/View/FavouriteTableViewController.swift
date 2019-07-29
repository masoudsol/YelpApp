//
//  FavouriteCollectionViewController.swift
//  YelpApp
//
//  Created by Masoud Soleimani on 2019-07-28.
//  Copyright © 2019 Mas One. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {
    
    private var favNames:[String] = []
    
    override func viewDidLoad() {
        title = "Favourite"
        
        if let favouritesList = UserDefaults.standard.value(forKey: CollectionViewController.FAVOURITEKEY) as? [String : String] {
            favNames = Array(favouritesList.values)
        }
        
        tableView.tableFooterView = UIView()
        tableView.bounces = false
    }
    
}

extension FavouriteTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = favNames[indexPath.row]
        cell.imageView?.image = UIImage(named: "Star_On")
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favNames.count
    }
}

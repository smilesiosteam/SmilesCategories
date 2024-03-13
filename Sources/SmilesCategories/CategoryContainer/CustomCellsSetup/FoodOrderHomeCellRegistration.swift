//
//  FoodOrderHomeCellRegistration.swift
//  House
//
//  Created by Hanan Ahmed on 11/17/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesStoriesManager
import SmilesFilterAndSort
import UIKit

struct FoodOrderHomeCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        
        tableView.registerCellFromNib(CollectionsTableViewCell.self, withIdentifier: String(describing: CollectionsTableViewCell.self))
        
        tableView.registerCellFromNib(RestaurantsRevampTableViewCell.self, bundle: RestaurantsRevampTableViewCell.module)
        
        tableView.registerCellFromNib(StoriesTableViewCell.self, bundle: StoriesTableViewCell.module)
        
        tableView.registerCellFromNib(RecommendedResturantsTableViewCell.self, withIdentifier: String(describing: RecommendedResturantsTableViewCell.self))
        
        tableView.registerCellFromNib(TopOffersTableViewCell.self, bundle: TopOffersTableViewCell.module)
        
        tableView.registerCellFromNib(CuisinesTableViewCell.self, withIdentifier: String(describing: CuisinesTableViewCell.self))
        
        tableView.registerCellFromNib(TopBrandsTableViewCell.self, withIdentifier: String(describing: TopBrandsTableViewCell.self))
        
        tableView.registerCellFromNib(DeliveryAndPickupTableViewCell.self, withIdentifier: String(describing: DeliveryAndPickupTableViewCell.self))
        
    
        tableView.registerCellFromNib(SubscriptionTableViewCell.self, withIdentifier: String(describing: SubscriptionTableViewCell.self))
        tableView.registerCellFromNib(SubscriptionPromotionActionTableViewCell.self, withIdentifier: String(describing: SubscriptionPromotionActionTableViewCell.self))
        
        tableView.registerCellFromNib(NoFilteredResultFoundTVC.self, bundle: NoFilteredResultFoundTVC.module)
    }
}

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
import SmilesReusableComponents
import UIKit


struct CategoryDetailsCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        
        tableView.registerCellFromNib(CollectionsTableViewCell.self, bundle: CollectionsTableViewCell.module)
        
        tableView.registerCellFromNib(TopBrandsTableViewCell.self, bundle: TopBrandsTableViewCell.module)
        
        tableView.registerCellFromNib(RestaurantsRevampTableViewCell.self, bundle: RestaurantsRevampTableViewCell.module)
        
        tableView.registerCellFromNib(StoriesTableViewCell.self, bundle: StoriesTableViewCell.module)
        
        tableView.registerCellFromNib(RecommendedResturantsTableViewCell.self, bundle: RecommendedResturantsTableViewCell.module)

        tableView.registerCellFromNib(TopOffersTableViewCell.self, bundle: TopOffersTableViewCell.module)

        tableView.registerCellFromNib(CuisinesTableViewCell.self, bundle: CuisinesTableViewCell.module)

        tableView.registerCellFromNib(DeliveryAndPickupTableViewCell.self, bundle: DeliveryAndPickupTableViewCell.module)

        tableView.registerCellFromNib(SubscriptionTableViewCell.self, bundle: SubscriptionTableViewCell.module)

        tableView.registerCellFromNib(SubscriptionPromotionActionTableViewCell.self, bundle: SubscriptionPromotionActionTableViewCell.module)

        tableView.registerCellFromNib(NoFilteredResultFoundTVC.self, bundle: NoFilteredResultFoundTVC.module)
        
        tableView.registerCellFromNib(ItemCategoryTableViewCell.self, bundle: ItemCategoryTableViewCell.module)
        
        tableView.registerCellFromNib(CBDCreditCardBannerTVC.self, bundle: CBDCreditCardBannerTVC.module)
       
        tableView.registerCellFromNib(OcassionThemeCell.self, bundle: OcassionThemeCell.module)
    }
}

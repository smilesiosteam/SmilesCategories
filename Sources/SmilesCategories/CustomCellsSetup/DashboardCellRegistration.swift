//
//  HomeCellRegisterable.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 24/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities
import UIKit

struct DashboardCellRegistration: CellRegisterable {
    func register(for tableView: UITableView) {
        let customizable: CellRegisterable? = FoodOrderHomeCellRegistration()
        customizable?.register(for: tableView)
        
        tableView.registerCellFromNib(SubscriptionPromotionActionTableViewCell.self, bundle: SubscriptionPromotionActionTableViewCell.module)
        
        tableView.registerCellFromNib(ItemCategoryTableViewCell.self, bundle: ItemCategoryTableViewCell.module)
        
        tableView.registerCellFromNib(CBDCreditCardBannerTableViewCell.self, bundle: CBDCreditCardBannerTableViewCell.module)
       
        tableView.registerCellFromNib(OcassionThemeCell.self, bundle: OcassionThemeCell.module)
    
    }
}

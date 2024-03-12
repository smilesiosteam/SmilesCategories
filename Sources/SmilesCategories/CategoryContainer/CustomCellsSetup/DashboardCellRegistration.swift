//
//  HomeCellRegisterable.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 24/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities

struct DashboardCellRegistration: CellRegisterable {
    func register(for tableView: UITableView) {
        let customizable: CellRegisterable? = FoodOrderHomeCellRegistration()
        customizable?.register(for: tableView)
        
        // Register extra cells for home here
        tableView.registerCellFromNib(SubscriptionPromotionActionTableViewCell.self, withIdentifier: String(describing: SubscriptionPromotionActionTableViewCell.self))
        tableView.registerCellFromNib(ItemCategoryTableViewCell.self, withIdentifier: String(describing: ItemCategoryTableViewCell.self))
        tableView.registerCellFromNib(SpinWheelTurnsViewCell.self, withIdentifier: String(describing: SpinWheelTurnsViewCell.self))
        tableView.registerCellFromNib(ActionNeededTableViewCell.self, withIdentifier: String(describing: ActionNeededTableViewCell.self))
        tableView.registerCellFromNib(CBDCreditCardBannerTableViewCell.self, withIdentifier: String(describing: CBDCreditCardBannerTableViewCell.self))
        tableView.registerCellFromNib(OcassionThemeCell.self, withIdentifier: String(describing: OcassionThemeCell.self))
    }
}

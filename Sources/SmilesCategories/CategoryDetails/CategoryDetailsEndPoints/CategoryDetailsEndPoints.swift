//
//  CategoryDetailsEndPoints.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 26/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public enum CategoryDetailsEndPoints: String, CaseIterable {
    case offersCategoryList
    case offersFilters
    case CBDDetails
}

extension CategoryDetailsEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .offersCategoryList:
            return "home/get-offers-category-list"
        case .offersFilters:
            return "home/get-offers-filters"
        case .CBDDetails:
            return "profile/get-user-cbd-Detail"
        }
    }
}

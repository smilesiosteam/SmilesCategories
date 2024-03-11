//
//  ItemCategoriesResponseModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

struct ItemCategoriesResponseModel: Codable {
    var extTransactionId: String?
    var itemCategoriesDetails: [HomeItemCategoryDetails]?
    
    enum CodingKeys: String, CodingKey {
        case extTransactionId
        case itemCategoriesDetails
    }
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extTransactionId = try values.decodeIfPresent(String.self, forKey: .extTransactionId)
        itemCategoriesDetails = try values.decodeIfPresent([HomeItemCategoryDetails].self, forKey: .itemCategoriesDetails)
    }
}

//
//  ItemCategoriesResponseModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public struct ItemCategoriesResponseModel: Codable {
    public var extTransactionId: String?
    public var itemCategoriesDetails: [HomeItemCategoryDetails]?
    
    public enum CodingKeys: String, CodingKey {
        case extTransactionId
        case itemCategoriesDetails
    }
    
    public init() {
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extTransactionId = try values.decodeIfPresent(String.self, forKey: .extTransactionId)
        itemCategoriesDetails = try values.decodeIfPresent([HomeItemCategoryDetails].self, forKey: .itemCategoriesDetails)
    }
}

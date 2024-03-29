//
//  GroupItemCategoriesDetails.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public struct GroupItemCategoryDetails: Codable {
   public let groupId: Int?
   public let groupName: String?
   public let groupDesc: String?
   public let iconUrl: String?
    public let itemCategoriesDetails: [HomeItemCategoryDetails]?
    
    enum CodingKeys: String, CodingKey {
        case groupId, groupName, groupDesc, iconUrl, itemCategoriesDetails
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groupId = try values.decodeIfPresent(Int.self, forKey: .groupId)
        groupName = try values.decodeIfPresent(String.self, forKey: .groupName)
        groupDesc = try values.decodeIfPresent(String.self, forKey: .groupDesc)
        iconUrl = try values.decodeIfPresent(String.self, forKey: .iconUrl)
        itemCategoriesDetails = try values.decodeIfPresent([HomeItemCategoryDetails].self, forKey: .itemCategoriesDetails)

    }
}

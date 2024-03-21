//
//  HomeItemCategoriesDetails.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public struct HomeItemCategoryDetails: Codable {
   public let categoryId: Int?
   public let categoryName: String?
   public let redirectionUrl: String?
   public let categoryIconUrl: String?
   public let animationUrl: String?
   public let ribbonIconUrl: String?
   public let backgroundColor: String?
   public let firebaseEventName: String?
   public let searchTag: String?
   public let prority: Int?
   public let groupItemCategoriesDetails: [GroupItemCategoryDetails]?
    
    public enum CodingKeys: String, CodingKey {
        case categoryId, categoryName, redirectionUrl, categoryIconUrl, animationUrl, ribbonIconUrl, backgroundColor, firebaseEventName, searchTag, prority, groupItemCategoriesDetails
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        redirectionUrl = try values.decodeIfPresent(String.self, forKey: .redirectionUrl)
        categoryIconUrl = try values.decodeIfPresent(String.self, forKey: .categoryIconUrl)
        animationUrl = try values.decodeIfPresent(String.self, forKey: .animationUrl)
        ribbonIconUrl = try values.decodeIfPresent(String.self, forKey: .ribbonIconUrl)
        backgroundColor = try values.decodeIfPresent(String.self, forKey: .backgroundColor)
        firebaseEventName = try values.decodeIfPresent(String.self, forKey: .firebaseEventName)
        searchTag = try values.decodeIfPresent(String.self, forKey: .searchTag)
        prority = try values.decodeIfPresent(Int.self, forKey: .prority)
        groupItemCategoriesDetails = try values.decodeIfPresent([GroupItemCategoryDetails].self, forKey: .groupItemCategoriesDetails)

    }
}

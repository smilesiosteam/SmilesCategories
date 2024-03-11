//
//  HomeItemCategoriesDetails.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

struct HomeItemCategoryDetails: Codable {
    let categoryId: Int?
    let categoryName: String?
    let redirectionUrl: String?
    let categoryIconUrl: String?
    let animationUrl: String?
    let ribbonIconUrl: String?
    let backgroundColor: String?
    let firebaseEventName: String?
    let searchTag: String?
    let prority: Int?
    let groupItemCategoriesDetails: [GroupItemCategoryDetails]?
    
    enum CodingKeys: String, CodingKey {
        case categoryId, categoryName, redirectionUrl, categoryIconUrl, animationUrl, ribbonIconUrl, backgroundColor, firebaseEventName, searchTag, prority, groupItemCategoriesDetails
    }
    
    init(from decoder: Decoder) throws {
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

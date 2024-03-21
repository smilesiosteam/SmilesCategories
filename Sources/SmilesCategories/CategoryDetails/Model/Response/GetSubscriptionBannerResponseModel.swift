//
//  GetSubscriptionBannerResponseModel.swift
//  House
//
//  Created by Hanan Ahmed on 11/3/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities

public struct GetSubscriptionBannerResponseModel: Codable {
            
    public let isFoodSubscription: Bool?
    public let subscriptionBanner: SubscriptionsBanner?
    
    public enum CodingKeys: String, CodingKey {
        case isFoodSubscription
        case subscriptionBanner
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isFoodSubscription = try values.decodeIfPresent(Bool.self, forKey: .isFoodSubscription)
        subscriptionBanner = try values.decodeIfPresent(SubscriptionsBanner.self, forKey: .subscriptionBanner)
    }
}

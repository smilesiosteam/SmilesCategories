//
//  NearbyOffersResponseModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 05/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesOffers

public struct NearbyOffersResponseModel: Codable {
    public let lifestyleSubscriberFlag: Bool?
    public let umOffers: [OfferDO]?
     
    public enum CodingKeys: String, CodingKey {
        case lifestyleSubscriberFlag = "lifestyleSubscriberFlag"
        case umOffers = "UMOffers"
    }
}

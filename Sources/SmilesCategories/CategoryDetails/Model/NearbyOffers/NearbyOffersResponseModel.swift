//
//  NearbyOffersResponseModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 05/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesOffers

struct NearbyOffersResponseModel: Codable {
    let lifestyleSubscriberFlag: Bool?
    let umOffers: [OfferDO]?
    
    enum CodingKeys: String, CodingKey {
        case lifestyleSubscriberFlag = "lifestyleSubscriberFlag"
        case umOffers = "UMOffers"
    }
}

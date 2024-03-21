//
//  GetPopularRestaurantsResponseModel.swift
//  House
//
//  Created by Hanan Ahmed on 11/3/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities

public struct GetPopularRestaurantsResponseModel: Codable {
   public var restaurants: [Restaurant]?
   public var isLastPageReached: Bool?
   public var sectionName: String?
   public var sectionDescription: String?
   public var eventName: String?
    
    public enum CodingKeys: String, CodingKey {
        case restaurants
        case isLastPageReached
        case sectionName
        case sectionDescription
        case eventName
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        restaurants = try values.decodeIfPresent([Restaurant].self, forKey: .restaurants)
        isLastPageReached = try values.decodeIfPresent(Bool.self, forKey: .isLastPageReached)
        sectionName = try values.decodeIfPresent(String.self, forKey: .sectionName)
        sectionDescription = try values.decodeIfPresent(String.self, forKey: .sectionDescription)
        eventName = try values.decodeIfPresent(String.self, forKey: .eventName)
    }
}

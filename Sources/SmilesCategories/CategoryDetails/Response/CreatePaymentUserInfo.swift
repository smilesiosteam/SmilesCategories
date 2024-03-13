//
//  CreatePaymentRequestUserInfo.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on September 14, 2020

import Foundation

class CreatePaymentUserInfo : Codable {

        var locationId : String?
        var mambaId : String?

        enum CodingKeys: String, CodingKey {
                case locationId = "locationId"
                case mambaId = "mambaId"
        }
    
       required init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                locationId = try values.decodeIfPresent(String.self, forKey: .locationId)
                mambaId = try values.decodeIfPresent(String.self, forKey: .mambaId)
        }

    init(){}
}

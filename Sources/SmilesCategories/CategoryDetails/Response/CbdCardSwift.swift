//
//  CBDDetailsResponseModelCbdCard.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 18, 2020

import Foundation
import SmilesUtilities

class CbdCardSwift: Codable {
    let desc: String?
    let img: String?
    let promotionalDesc: String?
    let promotionalIcon: String?
    let promotionalTitle: String?
    let title: String?
    let termsAndConditionTitle: String?
    let termsAndCondition: String?
    let cbdPromotionType : String?
        
    enum CodingKeys: String, CodingKey {
        case desc
        case img
        case promotionalDesc
        case promotionalIcon
        case promotionalTitle
        case title
        case termsAndConditionTitle
        case termsAndCondition
        case cbdPromotionType
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        img = try values.decodeIfPresent(String.self, forKey: .img)
        promotionalDesc = try values.decodeIfPresent(String.self, forKey: .promotionalDesc)
        promotionalIcon = try values.decodeIfPresent(String.self, forKey: .promotionalIcon)
        promotionalTitle = try values.decodeIfPresent(String.self, forKey: .promotionalTitle)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        termsAndConditionTitle = try values.decodeIfPresent(String.self, forKey: .termsAndConditionTitle)
        termsAndCondition = try values.decodeIfPresent(String.self, forKey: .termsAndCondition)
        cbdPromotionType = try values.decodeIfPresent(String.self, forKey: .cbdPromotionType)
    }
    
    func asDictionary() -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded
    }
}

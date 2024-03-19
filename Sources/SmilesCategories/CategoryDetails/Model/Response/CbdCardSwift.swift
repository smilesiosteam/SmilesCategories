//
//  CBDDetailsResponseModelCbdCard.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 18, 2020

import Foundation
import SmilesUtilities

public class CbdCardSwift: Codable {
    public let desc: String?
    public let img: String?
    public let promotionalDesc: String?
    public let promotionalIcon: String?
    public let promotionalTitle: String?
    public let title: String?
    public let termsAndConditionTitle: String?
    public let termsAndCondition: String?
    public let cbdPromotionType : String?
        
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

    public required init(from decoder: Decoder) throws {
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

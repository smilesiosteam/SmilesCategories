//
//  CBDDetailsResponseModelCbdCardDetailsList.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 18, 2020

import Foundation

class CbdCardDetailsListSwift: Codable {
    let desc: String?
    let icon: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case desc
        case icon
        case title
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if desc != nil {
            dictionary["desc"] = desc
        }
        if icon != nil {
            dictionary["icon"] = icon
        }
        if title != nil {
            dictionary["title"] = title
        }
        return dictionary
    }
}

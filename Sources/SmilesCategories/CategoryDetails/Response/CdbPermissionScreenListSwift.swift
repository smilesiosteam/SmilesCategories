//
//  CBDDetailsResponseModelCdbPermissionScreenList.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 18, 2020

import Foundation

class CdbPermissionScreenListSwift: Codable {
    let billAndRechargePage: Bool?
    let cashVoucher: Bool?
    let dealVoucher: Bool?
    let discountVoucher: Bool?
    let paymentPage: Bool?
    let paymentSuccessfulPage: Bool?

    enum CodingKeys: String, CodingKey {
        case billAndRechargePage
        case cashVoucher
        case dealVoucher
        case discountVoucher
        case paymentPage
        case paymentSuccessfulPage
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        billAndRechargePage = try values.decodeIfPresent(Bool.self, forKey: .billAndRechargePage)
        cashVoucher = try values.decodeIfPresent(Bool.self, forKey: .cashVoucher)
        dealVoucher = try values.decodeIfPresent(Bool.self, forKey: .dealVoucher)
        discountVoucher = try values.decodeIfPresent(Bool.self, forKey: .discountVoucher)
        paymentPage = try values.decodeIfPresent(Bool.self, forKey: .paymentPage)
        paymentSuccessfulPage = try values.decodeIfPresent(Bool.self, forKey: .paymentSuccessfulPage)
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if billAndRechargePage != nil {
            dictionary["billAndRechargePage"] = billAndRechargePage
        }
        if cashVoucher != nil {
            dictionary["cashVoucher"] = cashVoucher
        }
        if dealVoucher != nil {
            dictionary["dealVoucher"] = dealVoucher
        }
        if discountVoucher != nil {
            dictionary["discountVoucher"] = discountVoucher
        }
        if paymentPage != nil {
            dictionary["paymentPage"] = paymentPage
        }
        if paymentSuccessfulPage != nil {
            dictionary["paymentSuccessfulPage"] = paymentSuccessfulPage
        }
        return dictionary
    }
}

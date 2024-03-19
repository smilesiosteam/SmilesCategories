/*
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import SmilesUtilities

class PaymentInfoRequestModel: Codable {
    var accountType: String?
    var paymentItemType: Int?
    var menuItemType: String?
    var restaurantId:String?
    var userInfo : CreatePaymentUserInfo?
    var isRecipientChange : Bool?
    var isHideCodPayment: Bool?
    var hidePaymentMethods: [String]?
    var offerId : String?
    var autoRenewable : Bool?
    var couponType : String?
    var offerType: OfferType?
    var sourceClick: String?
    
    enum CodingKeys: String, CodingKey {
        case accountType
        case paymentItemType
        case menuItemType
        case restaurantId
        case userInfo
        case isRecipientChange
        case isHideCodPayment
        case hidePaymentMethods
        case offerId
        case autoRenewable
        case couponType
        case offerType
        case sourceClick
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountType = try values.decodeIfPresent(String.self, forKey: .accountType)
        paymentItemType = try values.decodeIfPresent(Int.self, forKey: .paymentItemType)
        menuItemType = try values.decodeIfPresent(String.self, forKey: .menuItemType)
        restaurantId = try values.decodeIfPresent(String.self, forKey: .restaurantId)
        isRecipientChange = try values.decodeIfPresent(Bool.self, forKey: .isRecipientChange)
        userInfo = try values.decodeIfPresent(CreatePaymentUserInfo.self, forKey: .userInfo)
        isHideCodPayment = try values.decodeIfPresent(Bool.self, forKey: .isHideCodPayment)
        hidePaymentMethods = try values.decodeIfPresent([String].self, forKey: .hidePaymentMethods)
        offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
        autoRenewable = try values.decodeIfPresent(Bool.self, forKey: .autoRenewable)
        couponType = try values.decodeIfPresent(String.self, forKey: .couponType)
        offerType = try values.decodeIfPresent(OfferType.self, forKey: .offerType)
        sourceClick = try values.decodeIfPresent(String.self, forKey: .sourceClick)
    }
    
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
}

@objc class PaymentInfoModel: NSObject {
    @objc static let shared = PaymentInfoModel()
    var restaurantId: String?
    var addressId: String?
    var totalAmount: Double?
    var totalPoints: Int?
    var totalItems: Int?
    var deliveryCharges: String?
    @objc var isRecipientChange : Bool = false
    @objc var recipientName : String = ""
    @objc var recipientNumber: String = ""
    var isHideCodPayment: Bool? = false
    @objc var lastSelectedCategory: String = ""
    @objc var restaurantName: String = ""
    @objc var promoCode: String = ""
    var cartId: String = ""
    @objc var inlineItemCode: String?
    var isCustomerCardConsent: Bool = true
    var isComingFromSpecialOffer: Bool = false
    private override init() {}
}

class OrderInfoModel {
    static let shared = OrderInfoModel()
    var orderType: RestaurantMenuType?
    var address: String?
    var restaurantAddress: String?
    var restaurantId : String?
    var orderTypeDefaultValue :RestaurantMenuType = .DELIVERY
    
    private init() {}
}

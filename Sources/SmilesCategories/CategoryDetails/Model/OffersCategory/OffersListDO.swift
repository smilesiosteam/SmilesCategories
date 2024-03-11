//
//  OffersListDO.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 26/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

struct OffersListDO: Codable {
    let categoryId : String?
    let categoryOrder : Int?
    let cinemaOfferFlag : Bool?
    let dirhamValue : String?
    let imageURL : String?
    var isWishlisted : Bool?
    let merchantDistance : String?
    let offerDescription : String?
    let offerId : String?
    let offerTitle : String?
    let offerType : String?
    let offerTypeAr : String?
    let partnerImage : String?
    let partnerName : String?
    let pointsValue : String?
    let originalPointsValue : String?
    let originalDirhamValue : String?
    let voucherPromoText : String?
    let isBirthdayOffer : Bool?
    let isRedeemedOffer : Bool?
    let birthdayTxt : String?
    let redeemedTxt : String?
    let smileyPointsUrl: String?
}

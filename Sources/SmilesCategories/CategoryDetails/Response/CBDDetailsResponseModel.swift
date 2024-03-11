//
//  CBDDetailsResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on February 18, 2020

import Foundation
import NetworkingLayer

class CBDDetailsResponseModel: BaseMainResponse {
    let cbdCard: CbdCardSwift?
    let cbdCardDetailsList: [CbdCardDetailsListSwift]?
    let cdbPermissionScreenList: CdbPermissionScreenListSwift?
    let contactNumber: String?
    let dob: String?
    let isCbdCardHolder: Bool?
    let language: String?
    let name: String?
    let nationality: Int?
    let email: String?
    let type: String?
    let userDetailSectionHidden: Bool?
    let isExternalRedirectionPopup: Bool?
    let cbdRedirectionUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case cbdCard
        case cbdCardDetailsList
        case cdbPermissionScreenList
        case contactNumber
        case dob
        case isCbdCardHolder
        case language
        case name
        case nationality
        case email
        case type
        case userDetailSectionHidden
        case isExternalRedirectionPopup
        case cbdRedirectionUrl
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cbdCard = try values.decodeIfPresent(CbdCardSwift.self, forKey: .cbdCard)
        cbdCardDetailsList = try values.decodeIfPresent([CbdCardDetailsListSwift].self, forKey: .cbdCardDetailsList)
        cdbPermissionScreenList = try values.decodeIfPresent(CdbPermissionScreenListSwift.self, forKey: .cdbPermissionScreenList)
        contactNumber = try values.decodeIfPresent(String.self, forKey: .contactNumber)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        isCbdCardHolder = try values.decodeIfPresent(Bool.self, forKey: .isCbdCardHolder)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nationality = try values.decodeIfPresent(Int.self, forKey: .nationality)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        userDetailSectionHidden = try values.decodeIfPresent(Bool.self, forKey: .userDetailSectionHidden)
        isExternalRedirectionPopup = try values.decodeIfPresent(Bool.self, forKey: .isExternalRedirectionPopup)
        cbdRedirectionUrl = try values.decodeIfPresent(String.self, forKey: .cbdRedirectionUrl)
        try super.init(from: decoder)
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        
        if userDetailSectionHidden != nil{
            dictionary["userDetailSectionHidden"] = userDetailSectionHidden
        }
        if isExternalRedirectionPopup != nil{
            dictionary["isExternalRedirectionPopup"] = isExternalRedirectionPopup
        }
        if contactNumber != nil {
            dictionary["contactNumber"] = contactNumber
        }
        if dob != nil {
            dictionary["dob"] = dob
        }
        if isCbdCardHolder != nil {
            dictionary["isCbdCardHolder"] = isCbdCardHolder
        }
        if cbdRedirectionUrl != nil {
            dictionary["cbdRedirectionUrl"] = cbdRedirectionUrl
        }
        if language != nil {
            dictionary["language"] = language
        }
        if name != nil {
            dictionary["name"] = name
        }
        if nationality != nil {
            dictionary["nationality"] = nationality
        }
        if email != nil {
            dictionary["email"] = email
        }
        if type != nil {
            dictionary["type"] = type
        }
        if cbdCard != nil {
            dictionary["cbdCard"] = cbdCard?.asDictionary()
        }
        if cdbPermissionScreenList != nil {
            dictionary["cdbPermissionScreenList"] = cdbPermissionScreenList?.toDictionary()
        }
        if cbdCardDetailsList != nil {
            var dictionaryElements = [[String: Any]]()
            for cbdCardDetailsListElement in cbdCardDetailsList ?? [] {
                dictionaryElements.append(cbdCardDetailsListElement.toDictionary())
            }
            dictionary["cbdCardDetailsList"] = dictionaryElements
        }
        return dictionary
    }
}

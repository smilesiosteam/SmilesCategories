//
//  SaveUserCbdDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 25, 2019

import Foundation
import SmilesUtilities

class SaveUserCbdDetailRequset : Codable {
    
    var contactNumber : String?
    var dob : String?
    var email : String?
    var language : String?
    var name : String?
    var nationality : Int?
    var cbdPromotionType : String?
    
    enum CodingKeys: String, CodingKey {
        case contactNumber = "contactNumber"
        case dob = "dob"
        case email = "email"
        case language = "language"
        case name = "name"
        case nationality = "nationality"
        case cbdPromotionType
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contactNumber = try values.decodeIfPresent(String.self, forKey: .contactNumber)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nationality = try values.decodeIfPresent(Int.self, forKey: .nationality)
        cbdPromotionType = try values.decodeIfPresent(String.self, forKey: .cbdPromotionType)
    }
    
    
    init() {}
    
    
    func asDictionary(dictionary :[String : Any]) -> [String : Any] {
        
        let encoder = DictionaryEncoder()
        guard  let encoded = try? encoder.encode(self) as [String:Any]  else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary:dictionary)
        
    }
    
}

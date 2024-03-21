//
//  SaveUserCbdDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 25, 2019

import Foundation
import SmilesUtilities

public class SaveUserCbdDetailRequset : Codable {
    
    public var contactNumber : String?
    public var dob : String?
    public var email : String?
    public var language : String?
    public var name : String?
    public var nationality : Int?
    public var cbdPromotionType : String?
    
    public enum CodingKeys: String, CodingKey {
        case contactNumber = "contactNumber"
        case dob = "dob"
        case email = "email"
        case language = "language"
        case name = "name"
        case nationality = "nationality"
        case cbdPromotionType
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contactNumber = try values.decodeIfPresent(String.self, forKey: .contactNumber)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nationality = try values.decodeIfPresent(Int.self, forKey: .nationality)
        cbdPromotionType = try values.decodeIfPresent(String.self, forKey: .cbdPromotionType)
    }
    
    
    public init() {}
    
    
    public func asDictionary(dictionary :[String : Any]) -> [String : Any] {
        
        let encoder = DictionaryEncoder()
        guard  let encoded = try? encoder.encode(self) as [String:Any]  else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary:dictionary)
        
    }
    
}

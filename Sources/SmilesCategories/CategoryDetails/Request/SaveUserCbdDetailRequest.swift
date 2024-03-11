//
//  SaveUserCbdDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 25, 2019

import Foundation

struct SaveUserCbdDetail : Codable {

        let contactNumber : String?
        let dob : String?
        let email : String?
        let language : String?
        let name : String?
        let nationality : String?

        enum CodingKeys: String, CodingKey {
                case contactNumber = "contactNumber"
                case dob = "dob"
                case email = "email"
                case language = "language"
                case name = "name"
                case nationality = "nationality"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                contactNumber = try values.decodeIfPresent(String.self, forKey: .contactNumber)
                dob = try values.decodeIfPresent(String.self, forKey: .dob)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                language = try values.decodeIfPresent(String.self, forKey: .language)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
        }

}

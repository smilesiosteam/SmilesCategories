//
//  CategoryContainerRequestModel.swift
//  House
//
//  Created by Shahroze Zaheer on 21/12/2022.
//  Copyright (c) 2022 All rights reserved.
//


import Foundation

// Inherit SmilesBaseMainRequest instead of Codable in case you have some base class.
class CategoryContainerRequestModel: Codable {
    
    // MARK: - Model Variables
    
    var value1: String?
    var value2: String?
    
    // MARK: - Model Keys
    
    enum CodingKeys: String, CodingKey{
        case value1
        case value2
    }
    
    
}

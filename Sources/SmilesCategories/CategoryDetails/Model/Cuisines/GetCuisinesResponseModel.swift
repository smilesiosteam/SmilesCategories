//
//  GetCuisinesResponseModel.swift
//  House
//
//  Created by Hanan Ahmed on 10/31/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public struct GetCuisinesResponseModel: Codable {
    
    public let cuisines: [CuisineDO]?
    
   public struct CuisineDO: Codable {
        // MARK: - Model Variables
        
       public let title: String?
       public let description: String?
       public let imageUrl: String?
       public let iconUrl: String?
       public let redirectionUrl: String?
        
    }
}

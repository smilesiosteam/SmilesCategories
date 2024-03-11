//
//  NearbyOffersRequestModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 05/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesBaseMainRequestManager

class NearbyOffersRequestModel: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    var pageNo: Int?
    var operationName: String?
    var isGuestUser: Bool?
    
    init(pageNo: Int?, operationName: String?, isGuestUser: Bool?) {
        super.init()
        self.pageNo = pageNo
        self.operationName = operationName
        self.isGuestUser = isGuestUser
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
        case pageNo
        case operationName
        case isGuestUser
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.pageNo, forKey: .pageNo)
        try container.encodeIfPresent(self.operationName, forKey: .operationName)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
    }
}

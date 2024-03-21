//
//  ItemCategoriesRequestModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesBaseMainRequestManager

public class ItemCategoriesRequestModel: SmilesBaseMainRequest {
    public var isGuestUser: Bool?
    
    public init(isGuestUser: Bool?) {
        super.init()
        self.isGuestUser = isGuestUser
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    enum CodingKeys: CodingKey {
        case isGuestUser
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
    }
}

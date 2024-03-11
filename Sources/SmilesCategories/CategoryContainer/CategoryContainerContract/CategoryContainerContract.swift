//
//  CategoryContainerContract.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 13/01/2023.
//  Copyright © 2023 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesSharedServices

extension CategoryContainerViewModel {
    // MARK: - INPUT. View event methods
    
    enum Input {
        case getSections(categoryID: Int, subCategoryId: Int? = nil)
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
    }
}

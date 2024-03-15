//
//  File.swift
//  
//
//  Created by Asad Ullah on 14/03/2024.
//

import Foundation
import UIKit

public struct CategoriesConfigurator {
   
    public enum ConfiguratorType {
        case categoriesContainerVC(dependencies: SmilesCategoryContainerDependencies)
    }
    
    public static func create(type: ConfiguratorType) -> UIViewController {
        switch type {
        case .categoriesContainerVC(let dependencies):
            return CategoryContainerViewController(dependencies: dependencies)
        }
    }
    
}
 
public struct SmilesCategoryContainerDependencies {
    
    let deelegate: SmilesCategoriesDelegate?
    let categoryId: Int 
    let shouldShowBills: Bool
    let sortType: String
    let isFromViewAll: Bool
    let isFromGifting: Bool = false
    let isFromSummary: Bool = false
}

public protocol SmilesCategoriesDelegate: AnyObject {
    func smilesCategoriesAnalytics(event: EventType, parameters: [String: String]?)
}

public enum EventType {
    case ClickOnOffer
    case ClickOnTopBrands
    case ClickOnStory
}

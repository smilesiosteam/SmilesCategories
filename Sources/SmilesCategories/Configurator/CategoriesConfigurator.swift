//
//  File.swift
//  
//
//  Created by Asad Ullah on 14/03/2024.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesStoriesManager
import SmilesOffers
import SmilesFilterAndSort

public struct CategoriesConfigurator {
   
    public enum ConfiguratorType {
        case categoriesContainerVC(dependencies: SmilesCategoryContainerDependencies)
        case categoryDetailsViewController(dependencies: SmilesCategoryDetailsDependencies)
    }
    
    public static func create(type: ConfiguratorType) -> UIViewController {
        switch type {
        case .categoriesContainerVC(let dependencies):
            return CategoryContainerViewController(dependencies: dependencies)
        case .categoryDetailsViewController(let dependencies):
            return CategoryDetailsViewController(dependencies: dependencies)
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

public struct SmilesCategoryDetailsDependencies {
    
    let delegate: SmilesCategoriesDelegate?
    var consentConfigList : [ConsentConfigDO]?
    var categoryId: Int?
    var themeId: Int?
    var subCategoryId: Int?
    var sortType: String?
    var didScroll: (UIScrollView) -> Void = { _ in }
    var isFromViewAll: Bool?
    var personalizationEventSource: String?
}

public protocol SmilesCategoriesDelegate: AnyObject {
    func smilesCategoriesAnalytics(event: EventType, parameters: [String: String]?)
    func navigateToGlobalSearchVC()
    func navigateToUpdateLocationVC()
    func navigateToTransactionsListViewController(personalizationEventSource: String?)
    func navigateToBillPayRevamp(personalizationEventSource: String?)
   
    // Detail
    func navigateToRestaurantDetailVC(restaurant:Restaurant, isViewCart: Bool,
                                      recommendationModelEvent: String?, personalizationEventSource: String?)
    
    func navigateToStoriesDetailVC(stories: [Story]?, storyIndex:Int?, favouriteUpdatedCallback: ((_ storyIndex:Int,_ snapIndex:Int,_ isFavourite:Bool) -> Void)?)
    func presentCategoryPicker(groups: [GroupItemCategoryDetails])
    func navigateToOfferDetail(offer: OfferDO?, isFromDealsForYouSection: Bool?, personalizationEventSource: String?)
    func navigateToFiltersVC(categoryId: Int, sortingType: String?, previousFiltersResponse: Data?, selectedFilters: [FilterValue]?, filterDelegate: SelectedFiltersDelegate?)
    func navigateToSortingVC(sorts: [FilterDO], delegate: SelectedSortDelegate)
    func handleBannerDeepLinkRedirections(url: String)
    
    func showGuestUserLoginPopUp()
    func currentPresentedViewController(viewController: UIViewController)

}

public enum EventType {
    case ClickOnOffer
    case ClickOnTopBrands
    case ClickOnStory
}

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
            let categoryContainerViewController = CategoryContainerViewController.instantiateFromStoryBoard(withStoryBoard: "CategoryContainer")
            categoryContainerViewController.initialiser(dependencies: dependencies)
            return categoryContainerViewController
            
        case .categoryDetailsViewController(let dependencies):
            let categoryContainerViewController = CategoryDetailsViewController.instantiateFromStoryBoard(withStoryBoard: "CategoryDetails")
            categoryContainerViewController.initialiser(dependencies: dependencies)
            return categoryContainerViewController
        }
    }
    
}
 
public struct SmilesCategoryContainerDependencies {
    
    public weak var delegate: SmilesCategoriesContainerDelegate?
    public let categoryId: Int?
    public let themeId: Int?
    public let subCategoryId: Int?
    public let shouldAddBillsController: Bool?
    public let isFromViewAll: Bool?
    public let isFromGifting: Bool?
    public let isFromSummary: Bool?
    
    public init(delegate: SmilesCategoriesContainerDelegate? = nil, categoryId: Int?, themeId: Int?, subCategoryId: Int?, shouldAddBillsController: Bool?, isFromViewAll: Bool?, isFromGifting: Bool? = false, isFromSummary: Bool? = false) {
        self.delegate = delegate
        self.categoryId = categoryId
        self.themeId = themeId
        self.subCategoryId = subCategoryId
        self.shouldAddBillsController = shouldAddBillsController
        self.isFromViewAll = isFromViewAll
        self.isFromGifting = isFromGifting
        self.isFromSummary = isFromSummary
    }
}

public struct SmilesCategoryDetailsDependencies {
    
    public weak var delegate: SmilesCategoriesDelegate?
    public var consentConfigList : [ConsentConfigDO]?
    public var categoryId: Int?
    public var themeId: Int?
    public var subCategoryId: Int?
    public var sortType: String?
    public var didScroll: (UIScrollView) -> Void = { _ in }
    public var isFromViewAll: Bool?
    public var personalizationEventSource: String?
    
    public init(delegate: SmilesCategoriesDelegate? = nil, consentConfigList: [ConsentConfigDO]? = nil, categoryId: Int? = nil, themeId: Int? = nil, subCategoryId: Int? = nil, sortType: String? = nil, didScroll: @escaping (UIScrollView) -> Void, isFromViewAll: Bool? = nil, personalizationEventSource: String? = nil) {
        self.delegate = delegate
        self.consentConfigList = consentConfigList
        self.categoryId = categoryId
        self.themeId = themeId
        self.subCategoryId = subCategoryId
        self.sortType = sortType
        self.didScroll = didScroll
        self.isFromViewAll = isFromViewAll
        self.personalizationEventSource = personalizationEventSource
    }
}

public protocol SmilesCategoriesContainerDelegate: AnyObject {
    func navigateToGlobalSearchVC()
    func navigateToUpdateLocationVC()
    func navigateToTransactionsListViewController(personalizationEventSource: String?)
    func navigateToBillPayRevamp(personalizationEventSource: String?)
    func currentPresentedViewController(viewController: UIViewController)
    func navigateToCategoryDetails(isFromViewAll: Bool?, personalizationEventSource: String?, themeId: Int? ,didScroll: @escaping (UIScrollView) -> Void)
    func removeChild(viewController: UIViewController)
}

public protocol SmilesCategoriesDelegate: AnyObject {
    func smilesCategoriesAnalytics(event: EventTypes, parameters: [String: String]?)
    func presentRestaurantsList(response:GetPopularRestaurantsResponseModel, onRestaurantPicked:@escaping ((Restaurant)->Void))
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

public enum EventTypes {
    case ClickOnOffer
    case ClickOnTopBrands
    case ClickOnStory
}

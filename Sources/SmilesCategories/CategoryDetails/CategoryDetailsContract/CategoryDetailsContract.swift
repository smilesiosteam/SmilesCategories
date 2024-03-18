//
//  CategoryDetailsContract.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 21/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import CoreLocation
import SmilesStoriesManager
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesReusableComponents

public extension CategoryDetailsViewModel {
    // MARK: - INPUT. View event methods
    
     enum Input {
        case getCuisines(categoryID: Int, menuItemType: String?)
        case getCBDDetails
        case getTopBrands(categoryID: Int, menuItemType: String?)
        case getCollections(categoryID: Int, menuItemType: String?)
        case getSections(categoryID: Int, subCategoryId: Int? = nil)
        case getStories(categoryID: Int)
        case getSubscriptionBanner(menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?)
        case routeToRestaurantDetail(restaurant: Restaurant, isViewCart: Bool?)
        case getItemCategories
        case getTopOffers(menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?)
        case getNearbyOffers(pageNo: Int?)
        case updateOfferWishlistStatus(operation: Int, offerId: String)
        case getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String = "1", subCategoryTypeIdsList: [String]?, themeId:String? = nil)
        case getOffersFilters(categoryId: Int, sortingType: String?, baseUrl: String,isGuestUser: Bool)
        case getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?, categoryId : Int? )
        case removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel)
        case getSortingList
        case generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?)
        case getPopularRestaurants(menuItemType: String?)
        case emptyOffersList
        case updateSortingWithSelectedSort(sortBy:SortingCategoriesTypes)
        
        // MARK: -- Have to refactor later
        
        case setFiltersSavedList(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?)
        case setSelectedSort(sortTitle: String?)
    }
    
    enum Output {
        
        case fetchCBDDetailsDidSucceed(response: CBDDetailsResponseModel)
        case fetchCBDDetailsDidFail(error: Error)
        
        case fetchCuisinesDidSucceed(response: GetCuisinesResponseModel)
        case fetchCuisinesDidFail(error: Error)
        
        case fetchTopBrandsDidSucceed(response: GetTopBrandsResponseModel)
        case fetchTopBrandsDidFail(error: Error)
        
        case fetchCollectionsDidSucceed(response: GetCollectionsResponseModel)
        case fetchCollectionDidFail(error: Error)
        
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchStoriesDidSucceed(response: Stories)
        case fetchDidFail(error: Error)
        
        case fetchSubscriptionBannerDidSucceed(response: GetTopOffersResponseModel)
        case fetchSubscriptionBannerDidFail(error: Error)
        
        case routeToRestaurantDetailDidSucceed(selectedRestaurant: Restaurant, isViewCart: Bool?)
        
        case fetchItemCategoriesDidSucceed(response: ItemCategoriesResponseModel)
        case fetchItemCategoriesDidFail(error: Error)
        
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
        case fetchTopOffersDidFail(error: Error)
        
        case fetchNearbyOffersDidSucceed(response: NearbyOffersResponseModel)
        case fetchNearbyOffersDidFail(error: Error)
        
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        
        case fetchOffersCategoryListDidSucceed(response: OffersCategoryResponseModel)
        case fetchOffersCategoryListDidFail(error: Error)
        
        case fetchOffersFiltersDidSucceed(response: OffersFiltersResponseModel)
        case fetchOffersFiltersDidFail(error: Error)
        
        case fetchFiltersDataSuccess(filters: [FiltersCollectionViewCellRevampModel], selectedSortingTableViewCellModel: FilterDO?)
        case fetchAllSavedFiltersSuccess(filtersList: [RestaurantRequestFilter], filtersSavedList: [RestaurantRequestWithNameFilter])
        
        case fetchPopularRestaurantsDidSucceed(response: GetPopularRestaurantsResponseModel, menuItemType: String?)
        case fetchPopularRestaurantsDidFail(error: Error)
        
        case fetchSavedFiltersAfterSuccess(filtersSavedList: [RestaurantRequestWithNameFilter])
        case fetchContentForSortingItems(baseRowModels: [BaseRowModel])
        
        case fetchSortingListDidSucceed
        
        case emptyOffersListDidSucceed
        
        case updateSortingWithSelectedSort(sortBy:SortingCategoriesTypes)
    }
}


//
//  SectionedTableViewDataSource.swift
//  House
//
//  Created by Syed Faraz Haider Zaidi on 02/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SkeletonView
import SmilesStoriesManager
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers
import SmilesBanners
import SmilesFilterAndSort
import UIKit


extension TableViewDataSource where Model == GetCollectionsResponseModel {
    static func make(forCollections collectionsObject: GetCollectionsResponseModel,
                     reuseIdentifier: String = "CollectionsTableViewCell", data : String, isDummy:Bool = false, completion:((GetCollectionsResponseModel.CollectionDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter{$0.collections?.count ?? 0 > 0},
            reuseIdentifier: reuseIdentifier,
            data:data,
            isDummy:isDummy
        ) { (collection, cell, data, indexPath) in
            guard let cell = cell as? CollectionsTableViewCell else {return}
            cell.collectionsData = collection.collections
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { collection in
                completion?(collection)
            }
        }
    }
}


extension TableViewDataSource where Model == GetSectionsResponseModel {
    static func make(forSections collectionsObject: GetSectionsResponseModel,
                     reuseIdentifier: String = "DeliveryAndPickupTableViewCell", data : String, isDummy:Bool = false, completion: ((RestaurantMenuType) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject],
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy:isDummy
        ) { (menuItemTypes, cell, data, indexPath) in
            guard let cell = cell as? DeliveryAndPickupTableViewCell else { return }
            cell.menuTypeCallback = { menuType in
                completion?(menuType)
            }
        }
    }
}


extension TableViewDataSource where Model == GetSubscriptionBannerResponseModel {
    static func make(forSubscription collectionsObject: GetSubscriptionBannerResponseModel,
                     reuseIdentifier: String = "SubscriptionTableViewCell", data : String, isDummy:Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject],
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy:isDummy
        ) { (subscription, cell, data, indexPath)  in
            guard let cell = cell as? SubscriptionTableViewCell else {return}
            if let cellData = subscription.subscriptionBanner {
                cell.configureCell(data: cellData)
                cell.setBackGroundColor(color: UIColor(hexString: data))
            }
        }
    }
}


extension TableViewDataSource where Model == GetTopOffersResponseModel {
    static func makeSubscription(forTopOffers collectionsObject: GetTopOffersResponseModel,
                     reuseIdentifier: String = "SubscriptionPromotionActionTableViewCell", data : String, isDummy:Bool = false, completion:((GetTopOffersResponseModel.TopOfferAdsDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.ads?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (topOffers, cell, data, indexPath) in
            guard let cell = cell as? SubscriptionPromotionActionTableViewCell else {return}
            cell.sliderTimeInterval = topOffers.sliderTimeout
            cell.collectionsData = topOffers.ads
            
           // cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { data in
                completion?(data)
            }
        }
    }
}


extension TableViewDataSource where Model == OfferDO {
    static func make(forNearbyOffers nearbyOffersObjects: [OfferDO], offerCellType: RestaurantsRevampTableViewCell.OfferCellType = .home,
                     reuseIdentifier: String = "RestaurantsRevampTableViewCell", data: String, isDummy: Bool = false, completion: ((Bool, String, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: nearbyOffersObjects,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? RestaurantsRevampTableViewCell else { return }
            cell.configureCell(with: offer)
            cell.offerCellType = offerCellType
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.favoriteCallback = { isFavorite, offerId in
                completion?(isFavorite, offerId, indexPath)
            }
        }
    }
}


extension TableViewDataSource where Model == GetTopOffersResponseModel {
    static func make(forTopOffers collectionsObject: GetTopOffersResponseModel,
                     reuseIdentifier: String = "TopOffersTableViewCell", data : String, isDummy:Bool = false, completion:((GetTopOffersResponseModel.TopOfferAdsDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.ads?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (topOffers, cell, data, indexPath) in
            guard let cell = cell as? TopOffersTableViewCell else {return}
            cell.sliderTimeInterval = topOffers.sliderTimeout
            cell.collectionsData = topOffers.ads
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { data in
                completion?(data)
            }
        }
    }
}
extension TableViewDataSource where Model == CBDDetailsResponseModel {
    static func make(objects: [CBDDetailsResponseModel]) -> TableViewDataSource {
        return TableViewDataSource(
            models: objects,
            reuseIdentifier: "CBDCreditCardBannerTableViewCell",
            data: "#FFFFFF",
            isDummy: false
        ) { (cbdDetails, cell, data, indexPath) in
            guard let cell = cell as? CBDCreditCardBannerTableViewCell else { return }
            cell.configure(details: cbdDetails)
        }
    }
}

extension TableViewDataSource where Model == NoFilteredResultCellModel {
    static func make(forNoFilteredResultFound noFilteredResultObject: NoFilteredResultCellModel, reuseIdentifier: String = "NoFilteredResultFoundTVC", data: String, isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: [noFilteredResultObject],
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (noFilteredResultObject, cell, data, indexPath) in
            guard let cell = cell as? NoFilteredResultFoundTVC else { return }
            cell.configureCell(with: noFilteredResultObject)
        }
    }
    
}
extension TableViewDataSource where Model == ItemCategoriesResponseModel {
    static func make(forItemCategories collectionsObject: ItemCategoriesResponseModel,
                     reuseIdentifier: String = "ItemCategoryTableViewCell", data: String, isDummy: Bool = false, verticalLayouting: Bool = false, completion: ((HomeItemCategoryDetails) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.itemCategoriesDetails?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (itemCategories, cell, data, indexPath)  in
            guard let cell = cell as? ItemCategoryTableViewCell else { return }
            cell.verticalLayouting = verticalLayouting
            cell.collectionsData = itemCategories.itemCategoriesDetails
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { itemCategory in
                completion?(itemCategory)
            }
        }
    }
}
extension TableViewDataSource where Model == GetPopularRestaurantsResponseModel {
    static func make(forPopularResturants collectionsObject: GetPopularRestaurantsResponseModel,
                     reuseIdentifier: String = "RecommendedResturantsTableViewCell", data : String, isDummy:Bool = false, completion:((Restaurant, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.restaurants?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy:isDummy
        ) { (resturants, cell, data, indexPath)  in
            guard let cell = cell as? RecommendedResturantsTableViewCell else {return}
            cell.collectionsData = resturants.restaurants
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { data in
                completion?(data, indexPath)
            }
        }
    }
}
extension TableViewDataSource where Model == GetCuisinesResponseModel {
    static func make(forCuisines collectionsObject: GetCuisinesResponseModel,
                     reuseIdentifier: String = "CuisinesTableViewCell" , data : String, isDummy:Bool = false, completion:((GetCuisinesResponseModel.CuisineDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.cuisines?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy:isDummy
        ) { (cuisines, cell, data, indexPath) in
            debugPrint(data)
            guard let cell = cell as? CuisinesTableViewCell else {return}
            cell.collectionsDataCuisine = cuisines.cuisines
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { cuisine in
                completion?(cuisine)
            }
        }
    }
}

extension TableViewDataSource where Model == Stories {
    static func make(forStories collectionsObject: Stories,
                     reuseIdentifier: String = "StoriesTableViewCell", data : String, isDummy:Bool = false, onClick:((Story) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.stories?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (stories, cell, data, indexPath) in
            guard let cell = cell as? StoriesTableViewCell else {return}
            cell.collectionsData = stories.stories
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { data in
                      debugPrint(data)
                onClick?(data)
            }
        }
    }
}

extension TableViewDataSource where Model == GetTopBrandsResponseModel {
    static func make(forBrands collectionsObject: GetTopBrandsResponseModel,
                     reuseIdentifier: String = "TopBrandsTableViewCell", data: String, isDummy: Bool = false, topBrandsType: TopBrandsTableViewCell.TopBrandsType, completion:((GetTopBrandsResponseModel.BrandDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.brands?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (topBrands, cell, data, indexPath) in
            guard let cell = cell as? TopBrandsTableViewCell else {return}
            cell.collectionsDataTopBrand = topBrands.brands
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.topBrandsType = topBrandsType
            cell.callBack = { brand in
                completion?(brand)
            }
        }
    }
}

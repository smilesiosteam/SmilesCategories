//
//  CategoryDetailsTableViewDelegate.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 21/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import AnalyticsSmiles
import SmilesStoriesManager
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesPersonalizationEvent
import SmilesSharedServices
import SmilesLoader
import UIKit

// MARK: - UITableViewDelegate
extension CategoryDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let secID = SectionIdentifier(rawValue: self.categoryDetailsSections?.sectionDetails?[safe: indexPath.section]?.sectionIdentifier ?? ""){
            switch secID {
            case .TOPPLACEHOLDER:
                break
            case .TOPBANNERS:
                break
            case .ITEMCATEGORIES:
                break
            case .GAMIFICATIONBANNER:
                break
            case .STORIES:
                break
            case .DODLISTING:
                
                if let offer = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>)?.models?[safe: indexPath.row] {
                    
                    if offer.recommendationModelType == .offer {
//                        let analyticsSmiles = AnalyticsSmiles(service: FirebaseAnalyticsService())
//                        analyticsSmiles.sendAnalyticTracker(trackerData: Tracker(eventType: AnalyticsEvent.firebaseEvent(.ClickOnOffer).name, parameters: [:]))
                        
                        if let isFromViewAll = self.isFromViewAll, isFromViewAll {
                            PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: "dfy_view_all_clicked", offerId: offer.offerId.asStringOrEmpty(), recommendationModelEvent: offer.recommendationModelEvent.asStringOrEmpty(), source: self.personalizationEventSource)
                        }
                        
                        if let eventName = self.categoryDetailsSections?.getEventName(for: SectionIdentifier.DODLISTING.rawValue), !eventName.isEmpty {
                            PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, offerId: offer.offerId.asStringOrEmpty(), recommendationModelEvent: offer.recommendationModelEvent.asStringOrEmpty(), source: self.personalizationEventSource)
                        }
                        
                        redirectToOfferDetail(offer: offer, isFromDealsForYouSection: true)
                    } else if offer.recommendationModelType == .food {
                        if let isFromViewAll = self.isFromViewAll, isFromViewAll {
                            PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: "dfy_view_all_clicked", restaurantId: offer.offerId.asStringOrEmpty(), menuItemType: "DELIVERY", recommendationModelEvent: offer.recommendationModelEvent.asStringOrEmpty(), source: self.personalizationEventSource)
                        }
                        
                        if let eventName = self.categoryDetailsSections?.getEventName(for: SectionIdentifier.DODLISTING.rawValue), !eventName.isEmpty {
                            PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, restaurantId: offer.offerId.asStringOrEmpty(), menuItemType: "DELIVERY", recommendationModelEvent: offer.recommendationModelEvent.asStringOrEmpty(), source: self.personalizationEventSource)
                        }
                        
                        redirectToRestaurantDetail(offer: offer)
                    }
                }
                
            case .TOPCOLLECTIONS:
                break
            case .TOPCUISINE:
                break
            case .RECOMMENDEDLISTING:
                break
            case .TOPBRANDS:
                break
            case .SUBSCRIPTIONBANNERS:
                if let subscription  = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<SubscriptionsBanner>)?.models?[safe: indexPath.row] {
                    
                    if let eventName = self.categoryDetailsSections?.getEventName(for: SectionIdentifier.SUBSCRIPTIONBANNERS.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, urlScheme: subscription.redirectionUrl.asStringOrEmpty(), source: self.personalizationEventSource)
                    }
                    handleBannerDeepLinkRedirections(url: subscription.redirectionUrl.asStringOrEmpty())
                }
            case .OFFERLISTING:
                if let offer = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>)?.models?[safe: indexPath.row] {
//                    let analyticsSmiles = AnalyticsSmiles(service: FirebaseAnalyticsService())
//                    analyticsSmiles.sendAnalyticTracker(trackerData: Tracker(eventType: AnalyticsEvent.firebaseEvent(.ClickOnOffer).name, parameters: [:]))
                    
                    if let eventName = self.categoryDetailsSections?.getEventName(for: SectionIdentifier.OFFERLISTING.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, offerId: offer.offerId.asStringOrEmpty(), recommendationModelEvent: offer.recommendationModelEvent.asStringOrEmpty(), source: self.personalizationEventSource)
                    }
                    redirectToOfferDetail(offer: offer, isFromDealsForYouSection: false)
                }
            case .ORDERHISTORY:
                break
            case .RESTAURANTLISTING:
                break
            case .CBDBANNER:break//handle
            case .SUBSCRIPTIONBANNERSV2:
                break
            case .THEME_SECTION:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch self.categoryDetailsSections?.sectionDetails?[safe: indexPath.section]?.sectionIdentifier {
        case SectionIdentifier.TOPPLACEHOLDER.rawValue:
            return 0
        case SectionIdentifier.TOPCOLLECTIONS.rawValue:
            return 190
        case SectionIdentifier.STORIES.rawValue:
            return 230
        case SectionIdentifier.ORDERHISTORY.rawValue:
            return 1
        case SectionIdentifier.TOPBRANDS.rawValue:
            return 124
        case SectionIdentifier.RECOMMENDEDLISTING.rawValue:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !(self.sections.isEmpty){
            if let restaurantListingIndex = getSectionIndex(for: .OFFERLISTING), section != restaurantListingIndex {
                if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
                    return CGFloat.leastNormalMagnitude
                }
            }
        }else {
            if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 && !self.didSelectFilterOrSort {
                return CGFloat.leastNormalMagnitude
            }
        }
        if (self.categoryDetailsSections?.sectionDetails?[safe: section]?.sectionIdentifier == SectionIdentifier.SUBSCRIPTIONBANNERSV2.rawValue) {
            return CGFloat.leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if !(self.sections.isEmpty){
            if let restaurantListingIndex = getSectionIndex(for: .OFFERLISTING), section != restaurantListingIndex {
                if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
                    return nil
                }
            }
        }else {
            if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 && !self.didSelectFilterOrSort {
                return nil
            }
        }
        if (self.categoryDetailsSections?.sectionDetails?[safe: section]?.sectionIdentifier == SectionIdentifier.SUBSCRIPTIONBANNERSV2.rawValue) {
            return nil
        }
        if let sectionData = self.categoryDetailsSections?.sectionDetails?[safe: section] {
            if (sectionData.sectionIdentifier == SectionIdentifier.OFFERLISTING.rawValue) && (sectionData.isFilterAllowed != 0 || sectionData.isSortAllowed != 0) {
                self.input.send(.getFiltersData(filtersSavedList: self.filtersSavedList, isFilterAllowed: sectionData.isFilterAllowed, isSortAllowed: sectionData.isSortAllowed,categoryId : sectionData.categoryId)) // Get Filters Data
                let filtersCell = tableView.dequeueReusableCell(withIdentifier: "FiltersTableViewCell") as! FiltersTableViewCell
                filtersCell.title.text = sectionData.title
                filtersCell.title.setTextSpacingBy(value: -0.2)
                filtersCell.subTitle.text = sectionData.subTitle
                filtersCell.filtersData = self.filtersData
                filtersCell.backgroundColor = UIColor(hexString: sectionData.backgroundColor ?? "")
                
                filtersCell.callBack = { [weak self] filterData in
                    if filterData.tag == RestaurantFiltersType.filters.rawValue {
                        self?.redirectToOffersFilters()
                    } else if filterData.tag == RestaurantFiltersType.deliveryTime.rawValue {
                        // Delivery time                        
                        self?.redirectToSortingPopUp()
                    }else if filterData.tag == SortingCategoriesTypes.discount.rawValue{
                        self?.input.send(.updateSortingWithSelectedSort(sortBy: SortingCategoriesTypes.discount))
                    }
                    else if filterData.tag == SortingCategoriesTypes.cashVoucher.rawValue{
                        self?.input.send(.updateSortingWithSelectedSort(sortBy: SortingCategoriesTypes.cashVoucher))
                    }
                    else if filterData.tag == SortingCategoriesTypes.dealVoucher.rawValue{
                        self?.input.send(.updateSortingWithSelectedSort(sortBy: SortingCategoriesTypes.dealVoucher))
                    }
                    else {
                        // Remove and saved filters
                        self?.input.send(.removeAndSaveFilters(filter: filterData))
                    }
                }
                
                let sectionIdentifier = sectionData.sectionIdentifier
                if sectionIdentifier == self.mutatingSectionDetails.first?.sectionIdentifier {
                    filtersCell.stackViewTopConstraint.constant = 0
                } else {
                    if sectionIdentifier != SectionIdentifier.ITEMCATEGORIES.rawValue && sectionIdentifier != SectionIdentifier.GAMIFICATIONBANNER.rawValue {
                        filtersCell.stackViewTopConstraint.constant = 20
                    }
                }
                
                self.configureHeaderForShimmer(section: section, headerView: filtersCell)
                return filtersCell
            } else {
                let headerView = FoodHeaderNib()
                headerView.title.text = sectionData.title
                headerView.title.setTextSpacingBy(value: -0.2)
                headerView.subTitle.text = sectionData.subTitle
                headerView.setBackgroundColor(color: UIColor(hexString: sectionData.backgroundColor ?? "#FFFFFF"))

                let sectionIdentifier = sectionData.sectionIdentifier
                if sectionIdentifier == self.mutatingSectionDetails.first?.sectionIdentifier {
                    headerView.stackViewTopConstraint.constant = 0
                } else {
                    if sectionIdentifier != SectionIdentifier.ITEMCATEGORIES.rawValue && sectionIdentifier != SectionIdentifier.GAMIFICATIONBANNER.rawValue {
                        headerView.stackViewTopConstraint.constant = 20
                    }
                }
                
                self.configureHeaderForShimmer(section: section, headerView: headerView)
                return headerView
            }
        }
        return nil
    }
    
    func configureHeaderForShimmer(section:Int, headerView:UIView){
        func showHide(isDummy:Bool){
            if isDummy {
                headerView.enableSkeleton()
                headerView.showAnimatedGradientSkeleton()
            } else {
                headerView.hideSkeleton()
            }
        }
        if let sectionData = self.categoryDetailsSections?.sectionDetails?[safe: section], let secID = SectionIdentifier(rawValue: sectionData.sectionIdentifier ?? ""){
            switch  secID {
            case .ORDERHISTORY:
                if let dataSource = self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetOrderHistoryDOResponse>{
                    showHide(isDummy: dataSource.isDummy)
                }
            case .TOPBANNERS:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetTopOffersResponseModel>){
                    showHide(isDummy: dataSource.isDummy)
                }
                
            case .ITEMCATEGORIES:
                if let dataSource  = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<ItemCategoriesResponseModel>) {
                    showHide(isDummy: dataSource.isDummy)
                }
                
            case .GAMIFICATIONBANNER:
//                if let dataSource  = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<SpinWheelTurnsViewRevampCellModel>) {
//                    showHide(isDummy: dataSource.isDummy)
//                }
                break
            case .TOPCUISINE:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetCuisinesResponseModel>){
                    showHide(isDummy: dataSource.isDummy)
                }
            case .RECOMMENDEDLISTING:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetPopularRestaurantsResponseModel>){
                    showHide(isDummy: dataSource.isDummy)
                }
            case .TOPCOLLECTIONS:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetCollectionsResponseModel>){
                    showHide(isDummy: dataSource.isDummy)
                }
            case .STORIES:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<Stories>){
                    showHide(isDummy: dataSource.isDummy)
                }
            case .DODLISTING:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<OfferDO>) {
                    showHide(isDummy: dataSource.isDummy)
                }
            case .TOPBRANDS:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetTopBrandsResponseModel>){
                    showHide(isDummy: dataSource.isDummy)
                }
            case .SUBSCRIPTIONBANNERS:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<GetTopOffersResponseModel>){
                    showHide(isDummy: dataSource.isDummy)
                }
            case .OFFERLISTING:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<OfferDO>){
                    showHide(isDummy: dataSource.isDummy)
                }
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let offersIndex = getSectionIndex(for: .OFFERLISTING) {
            if indexPath.section == offersIndex {
                let lastItem = self.offers.endIndex - 1
                if indexPath.row == lastItem {
                    if (offersListing?.offersCount ?? 0) != self.offers.count {
                        offersPage += 1
                        tableView.tableFooterView = PaginationLoaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 44))
                        self.input.send(.getOffersCategoryList(pageNo: offersPage, categoryId: "\(self.offersCategoryId)", searchByLocation: false, sortingType: sortingType, subCategoryId: "1", subCategoryTypeIdsList: arraySelectedSubCategoryTypes, themeId: (themeId != nil) ? "\(self.themeId!)" : nil))
                    }
                }
            }
        } else if let offersIndex = getSectionIndex(for: .DODLISTING) {
            if indexPath.section == offersIndex {
                let lastItem = self.dodOffers.endIndex - 1
                if indexPath.row == lastItem {
                    if !dodOffers.isEmpty {
                        dodOffersPage += 1
                        self.input.send(.getNearbyOffers(pageNo: dodOffersPage))
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView)
        if let indexPath = tableView.indexPath(for: tableView.visibleCells.first ?? UITableViewCell()) {
            let backgroundColor = self.categoryDetailsSections?.sectionDetails?[safe: indexPath.section]?.backgroundColor
            if let parentViewController = self.parent as? CategoryContainerViewController {
                if !parentViewController.shouldAddBillsController {
                    parentViewController.topHeaderView.setBackgroundColorForCurveView(color: UIColor(hexString: backgroundColor.asStringOrEmpty()))
                } else {
                    parentViewController.topHeaderView.setBackgroundColorForTabsCurveView(color: UIColor(hexString: backgroundColor.asStringOrEmpty()))
                }
            }
        }
    }
}

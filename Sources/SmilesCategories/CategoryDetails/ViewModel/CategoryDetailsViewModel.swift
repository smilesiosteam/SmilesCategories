//
//  CategoryDetailsViewModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 21/12/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import Combine
import SmilesStoriesManager
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesLocationHandler

class CategoryDetailsViewModel {
    
    // MARK: -- Variables
    
    private let cuisinesViewModel = CuisinesViewModel()
    private let topBrandsViewModel = TopBrandsViewModel()
    private let collectionsViewModel = CollectionsViewModel()
    private let sectionsViewModel = SectionsViewModel()
    
    private let subscriptionBannerViewModel = DashboardSubscriptionViewModel()
    
    private let itemCategoriesViewModel = ItemCategoriesViewModel()
    private let topOffersViewModel = TopOffersViewModel()
    private let nearbyOffersViewModel = NearbyOffersViewModel()
    private let offersCategoryListViewModel = OffersCategoryListViewModel()
    private let offersFiltersViewModel = OffersFiltersViewModel()
    private let cbdViewModel = CBDDetailsViewModel()
    private let wishListViewModel = WishListViewModel()
    
    private var cuisinesUseCaseinput: PassthroughSubject<CuisinesViewModel.Input, Never> = .init()
    private var topBrandsUseCaseInput: PassthroughSubject<TopBrandsViewModel.Input, Never> = .init()
    private var collectionsUseCaseInput: PassthroughSubject<CollectionsViewModel.Input, Never> = .init()
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private let popularRestaurantsViewModel = PopularRestaurantsViewModel()
    
    private var subscriptionBannerUseCaseInput: PassthroughSubject<DashboardSubscriptionViewModel.Input, Never> = .init()
    
    private var itemCategoriesUseCaseInput :PassthroughSubject<ItemCategoriesViewModel.Input, Never> = .init()
    private var topOffersUseCaseInput: PassthroughSubject<TopOffersViewModel.Input, Never> = .init()
    private var nearbyOffersUseCaseInput: PassthroughSubject<NearbyOffersViewModel.Input, Never> = .init()
    private var offersCategoryListUseCaseInput: PassthroughSubject<OffersCategoryListViewModel.Input, Never> = .init()
    private var popularRestaurantsUseCaseInput: PassthroughSubject<PopularRestaurantsViewModel.Input, Never> = .init()
    private var offersFiltersUseCaseInput: PassthroughSubject<OffersFiltersViewModel.Input, Never> = .init()
    private var cbdDetailsUseCaseInput: PassthroughSubject<CBDDetailsViewModel.Input, Never> = .init()
    private var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var filtersSavedList: [RestaurantRequestWithNameFilter]?
    private var filtersList: [RestaurantRequestFilter]?
    private var selectedSortingTableViewCellModel: FilterDO?
    private var selectedSort: String?
}

// MARK: - INPUT. View event methods
extension CategoryDetailsViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
                
            case .getTopOffers(let menuItemType, let bannerType, let categoryId, let bannerSubType):
                self?.bind(to: self?.topOffersViewModel ?? TopOffersViewModel())
                self?.topOffersUseCaseInput.send(.getTopOffers(menuItemType: menuItemType, bannerType: bannerType, categoryId: categoryId, bannerSubType: bannerSubType, isGuestUser: AppCommonMethods.isGuestUser, baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .getTopBrands(let categoryID, let menuItemType):
                self?.bind(to: self?.topBrandsViewModel ?? TopBrandsViewModel())
                self?.topBrandsUseCaseInput.send(.getTopBrands(categoryID: categoryID, menuItemType: menuItemType ?? ""))
                
            case .getCuisines(let categoryID, let menuItemType):
                self?.bind(to: self?.cuisinesViewModel ?? CuisinesViewModel())
                self?.cuisinesUseCaseinput.send(.getCuisines(categoryID: categoryID, menuItemType: menuItemType))
                
            case .getCollections(categoryID: let categoryID, menuItemType: let menuItemType):
                self?.bind(to: self?.collectionsViewModel ?? CollectionsViewModel())
                self?.collectionsUseCaseInput.send(.getCollections(categoryID: categoryID, menuItemType: menuItemType))
                
            case .getSections(let categoryID, let subCategoryId):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, subCategoryId: subCategoryId, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser))
                
            case .getStories(let categoryID):
                SmilesStoriesHandler.shared.getStories(categoryId: categoryID, baseURL: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser) { storiesResponse in
                    self?.output.send(.fetchStoriesDidSucceed(response: storiesResponse))
                } failure: { error in
                    self?.output.send(.fetchDidFail(error: error))
                }
                
            case .getSubscriptionBanner(let menuItemType, let bannerType, let categoryId, let bannerSubType):
                self?.bind(to: self?.subscriptionBannerViewModel ?? DashboardSubscriptionViewModel())
                self?.subscriptionBannerUseCaseInput.send(.getSubscriptionBanner(menuItemType: menuItemType, bannerType: bannerType, categoryId: categoryId, bannerSubType: bannerSubType))
                
            case .routeToRestaurantDetail(let restaurant, let isViewCart):
                self?.output.send(.routeToRestaurantDetailDidSucceed(
                    selectedRestaurant: restaurant,
                    isViewCart: isViewCart)
                )
                
            case .getItemCategories:
                self?.bind(to: self?.itemCategoriesViewModel ?? ItemCategoriesViewModel())
                self?.itemCategoriesUseCaseInput.send(.getItemCategories)
                
            case .getNearbyOffers(let pageNo):
                self?.bind(to: self?.nearbyOffersViewModel ?? NearbyOffersViewModel())
                self?.nearbyOffersUseCaseInput.send(.getNearbyOffers(pageNo: pageNo))
                
            case .updateOfferWishlistStatus(let operation, let offerId):
                self?.bind(to: self?.wishListViewModel ?? WishListViewModel())
                self?.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .getOffersCategoryList(let pageNo, let categoryId, let searchByLocation, let sortingType, let subCategoryId, let subCategoryTypeIdsList, let themeId):
                
                var latitude = 0.0
                var longitude = 0.0
                
                if let userInfo = LocationStateSaver.getLocationInfo(){
                    latitude = Double(userInfo.latitude ?? "0.0") ?? 0.0
                    longitude = Double(userInfo.longitude ?? "0.0") ?? 0.0
                }
                
                self?.bind(to: self?.offersCategoryListViewModel ?? OffersCategoryListViewModel())
                self?.offersCategoryListUseCaseInput.send(.getOffersCategoryList(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList, latitude: latitude, longitude: longitude, themeId: themeId))
                
            case .getPopularRestaurants(let menuItemType):
                self?.bind(to: self?.popularRestaurantsViewModel ?? PopularRestaurantsViewModel())
                self?.popularRestaurantsUseCaseInput.send(.getPopularRestaurants(menuItemType: menuItemType))
                
            case .getOffersFilters(let categoryId, let sortingType, let baseUrl, let isGuestUser):
                self?.bind(to: self?.offersFiltersViewModel ?? OffersFiltersViewModel())
                self?.offersFiltersUseCaseInput.send(.getOffersFilters(categoryId: categoryId, sortingType: sortingType, baseUrl: baseUrl, isGuestUser: isGuestUser))
                
            case .getFiltersData(let filtersSavedList, let isFilterAllowed, let isSortAllowed, let categoryId ):
                self?.createFiltersData(filtersSavedList: filtersSavedList, isFilterAllowed: isFilterAllowed, isSortAllowed: isSortAllowed, categoryId: categoryId)
                
            case .removeAndSaveFilters(let filter):
                self?.removeAndSaveFilters(filter: filter)
                
            case .getSortingList:
                self?.output.send(.fetchSortingListDidSucceed)
                
            case .generateActionContentForSortingItems(let sortingModel):
                self?.generateActionContentForSortingItems(sortingModel: sortingModel)
                
            case .emptyOffersList:
                self?.output.send(.emptyOffersListDidSucceed)
                
            case .setFiltersSavedList(let filtersSavedList, let filtersList):
                self?.filtersSavedList = filtersSavedList
                self?.filtersList = filtersList
                
            case .setSelectedSort(let sortTitle):
                self?.selectedSort = sortTitle
            
            case .getCBDDetails:
                self?.bind(to: self?.cbdViewModel ?? CBDDetailsViewModel())
                self?.cbdDetailsUseCaseInput.send(.getCBDDetails)
            
            case .updateSortingWithSelectedSort(let sortBy):
                self?.output.send(.updateSortingWithSelectedSort(sortBy:sortBy))
            
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // MARK: -- Binding
    
    // Cuisine ViewModel Binding
    func bind(to cuisinesViewModel: CuisinesViewModel) {
        cuisinesUseCaseinput = PassthroughSubject<CuisinesViewModel.Input, Never>()
        let output = cuisinesViewModel.transform(input: cuisinesUseCaseinput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchCuisinesDidSucceed(let cuisinesResponse):
                    print(cuisinesResponse)
                    self?.output.send(.fetchCuisinesDidSucceed(response: cuisinesResponse))
                case .fetchCuisinesDidFail(let error):
                    self?.output.send(.fetchCuisinesDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // TopBrands ViewModel Binding
    func bind(to topBrandsViewModel: TopBrandsViewModel) {
        topBrandsUseCaseInput = PassthroughSubject<TopBrandsViewModel.Input, Never>()
        let output = topBrandsViewModel.transform(input: topBrandsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchTopBrandsDidSucceed(let topBrandsResponse):
                    print(topBrandsResponse)
                    self?.output.send(.fetchTopBrandsDidSucceed(response: topBrandsResponse))
                case .fetchTopBrandsDidFail(let error):
                    self?.output.send(.fetchTopBrandsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // Collections ViewModel Binding
    func bind(to collectionsViewModel: CollectionsViewModel) {
        collectionsUseCaseInput = PassthroughSubject<CollectionsViewModel.Input, Never>()
        let output = collectionsViewModel.transform(input: collectionsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchCollectionsDidSucceed(let collectionResponse):
                    print(collectionResponse)
                    self?.output.send(.fetchCollectionsDidSucceed(response: collectionResponse))
                case .fetchCollectionsDidFail(let error):
                    self?.output.send(.fetchCollectionDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // CBDDetails ViewModel Binding
    func bind(to viewModel: CBDDetailsViewModel) {
        cbdDetailsUseCaseInput = PassthroughSubject<CBDDetailsViewModel.Input, Never>()
        let output = viewModel.transform(input: cbdDetailsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchCBDDetailsDidSucceed(let response):
                    print(response)
                    self?.output.send(.fetchCBDDetailsDidSucceed(response: response))
                case .fetchCBDDetailsDidFail(let error):
                    self?.output.send(.fetchCBDDetailsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // Sections ViewModel Binding
    func bind(to sectionsViewModel: SectionsViewModel) {
        sectionsUseCaseInput = PassthroughSubject<SectionsViewModel.Input, Never>()
        let output = sectionsViewModel.transform(input: sectionsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    print(sectionsResponse)
                    self?.output.send(.fetchSectionsDidSucceed(response: sectionsResponse))
                case .fetchSectionsDidFail(let error):
                    self?.output.send(.fetchTopBrandsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // Item Categories ViewModel Binding
    func bind(to itemCategoriesViewModel: ItemCategoriesViewModel) {
        itemCategoriesUseCaseInput = PassthroughSubject<ItemCategoriesViewModel.Input, Never>()
        let output = itemCategoriesViewModel.transform(input: itemCategoriesUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchItemCategoriesDidSucceed(let itemCategoriesResponse):
                    print(itemCategoriesResponse)
                    self?.output.send(.fetchItemCategoriesDidSucceed(response: itemCategoriesResponse))
                case .fetchItemCategoriesDidFail(let error):
                    self?.output.send(.fetchItemCategoriesDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // TopOffers ViewModel Binding
    func bind(to topOffersViewModel: TopOffersViewModel) {
        topOffersUseCaseInput = PassthroughSubject<TopOffersViewModel.Input, Never>()
        let output = topOffersViewModel.transform(input: topOffersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchTopOffersDidSucceed(let topOffersResponse):
                    self?.output.send(.fetchTopOffersDidSucceed(response: topOffersResponse))
                case .fetchTopOffersDidFail(let error):
                    self?.output.send(.fetchTopOffersDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    // SubscriptionBanners ViewModel Binding
    func bind(to subscriptionBannersViewModel: DashboardSubscriptionViewModel) {
        subscriptionBannerUseCaseInput = PassthroughSubject<DashboardSubscriptionViewModel.Input, Never>()
        let output = subscriptionBannersViewModel.transform(input: subscriptionBannerUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSubscriptionBannersDidSucceed(let subscriptionBannersResponse):
                    self?.output.send(.fetchSubscriptionBannerDidSucceed(response: subscriptionBannersResponse))
                case .fetchSubscriptionBannersDidFail(let error):
                    self?.output.send(.fetchSubscriptionBannerDidFail(error: error))
                    break
                    //self?.output.send(.fetchSubscriptionV2BannerDidSucceed(response: response))
                }
            }.store(in: &cancellables)
    }
    
    // NearbyOffers ViewModel Binding
    func bind(to nearbyOffersViewModel: NearbyOffersViewModel) {
        nearbyOffersUseCaseInput = PassthroughSubject<NearbyOffersViewModel.Input, Never>()
        let output = nearbyOffersViewModel.transform(input: nearbyOffersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchNearbyOffersDidSucceed(let nearbyOffersResponse):
                    self?.output.send(.fetchNearbyOffersDidSucceed(response: nearbyOffersResponse))
                case .fetchNearbyOffersDidFail(let error):
                    self?.output.send(.fetchNearbyOffersDidFail(error: error))
                }
            }.store(in: &cancellables)
        
    }
    
    // OffersCategoryList ViewModel Binding
    func bind(to offersCategoryListViewModel: OffersCategoryListViewModel) {
        offersCategoryListUseCaseInput = PassthroughSubject<OffersCategoryListViewModel.Input, Never>()
        let output = offersCategoryListViewModel.transform(input: offersCategoryListUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchOffersCategoryListDidSucceed(let offersCategoryListResponse):
                    self?.output.send(.fetchOffersCategoryListDidSucceed(response: offersCategoryListResponse))
                case .fetchOffersCategoryListDidFail(let error):
                    self?.output.send(.fetchOffersCategoryListDidFail(error: error))
                }
            }.store(in: &cancellables)
        
    }
    
    // Popular Restaurants ViewModel Binding
    func bind(to popularRestaurantsViewModel: PopularRestaurantsViewModel) {
        popularRestaurantsUseCaseInput = PassthroughSubject<PopularRestaurantsViewModel.Input, Never>()
        let output = popularRestaurantsViewModel.transform(input: popularRestaurantsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchPopularRestaurantsDidSucceed(let popularRestaurantsResponse,let menuItemType):
                    debugPrint("menuItemType:\(menuItemType ?? "")" + (popularRestaurantsResponse.jsonString() ?? "NA"))
                    self?.output.send(.fetchPopularRestaurantsDidSucceed(response: popularRestaurantsResponse, menuItemType: menuItemType))
                case .fetchPopularRestaurantsDidFail(let error):
                    self?.output.send(.fetchPopularRestaurantsDidFail(error: error))
                    
                case .fetchPopupPopularRestaurantsDidSucceed(_,_):
                    break
                case .fetchPopupPopularRestaurantsDidFail(let error):
                    debugPrint(error.localizedDescription)
                case .updateWishlistStatusDidSucceed(response: let response):
                    self?.output.send(.updateWishlistStatusDidSucceed(response: response))
                }
            }.store(in: &cancellables)
    }
    
    // OffersFilters ViewModel Binding
    func bind(to offersFiltersViewModel: OffersFiltersViewModel) {
        offersFiltersUseCaseInput = PassthroughSubject<OffersFiltersViewModel.Input, Never>()
        let output = offersFiltersViewModel.transform(input: offersFiltersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchOffersFiltersDidSucceed(let offersFiltersResponse):
                    self?.output.send(.fetchOffersFiltersDidSucceed(response: offersFiltersResponse))
                case .fetchOffersFiltersDidFail(let error):
                    self?.output.send(.fetchOffersFiltersDidFail(error: error))
                }
            }.store(in: &cancellables)
        
    }
    
    // WishList ViewModel Binding
    func bind(to wishListViewModel: WishListViewModel) {
        wishListUseCaseInput = PassthroughSubject<WishListViewModel.Input, Never>()
        let output = wishListViewModel.transform(input: wishListUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .updateWishlistStatusDidSucceed(response: let response):
                    self?.output.send(.updateWishlistStatusDidSucceed(response: response))
                case .updateWishlistDidFail(error: let error):
                    debugPrint(error)
                    break
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: -- Filter and sorting

extension CategoryDetailsViewModel {
    func mapSortObjects(sorts: [String]) -> [FilterDO] {
        var filters: [FilterDO] = []
        
        for index in 0..<OfferSort.allCases.count {
            let filter = FilterDO()
            filter.name = sorts[index]
            filter.filterKey = "\(index)"
            filter.filterValue = "\(OfferSort.allCases[index].rawValue)"
            filter.isSelected = false
            filters.append(filter)
        }
        
        if let index = filters.firstIndex(where: { $0.name == selectedSortingTableViewCellModel?.name }) {
            filters[index].isSelected = true
        } else {
            let selectedFilters = filters.filter({ $0.isSelected ?? false })
            (selectedFilters.isEmpty && !filters.isEmpty) ? filters[0].isSelected = true : ()
        }
        
        return filters
    }
    
    // Create Filters Data
    func createFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?, categoryId:Int?) {
        var filters = [FiltersCollectionViewCellRevampModel]()
        
        // Filter List
        var firstFilter = FiltersCollectionViewCellRevampModel(name: "Filters".localizedString, leftImage: "", rightImage: "filter-icon-new", filterCount: filtersSavedList?.count ?? 0)
        
        let firstFilterRowWidth = AppCommonMethods.getAutoWidthWith(firstFilter.name, fontTextStyle: .smilesTitle1, additionalWidth: 60)
        firstFilter.rowWidth = firstFilterRowWidth
        
        let sortByTitle = !self.selectedSort.asStringOrEmpty().isEmpty ? "\("SortbyTitle".localizedString): \(self.selectedSort.asStringOrEmpty())" : "\("SortbyTitle".localizedString)"
        var secondFilter = FiltersCollectionViewCellRevampModel(name: sortByTitle, leftImage: "", rightImage: "", rightImageWidth: 0, rightImageHeight: 4, tag: RestaurantFiltersType.deliveryTime.rawValue)

        let secondFilterRowWidth = AppCommonMethods.getAutoWidthWith(secondFilter.name, fontTextStyle: .smilesTitle1, additionalWidth: 40)
        secondFilter.rowWidth = secondFilterRowWidth
        
        guard let sortData = AppCommonMethods.getLocalizedArray(forKey: "ViewAllSortCriteria") as? [String] else { return }
        
        var selectedIndex = -1
        if let selectedSort = self.selectedSort, !selectedSort.isEmpty{
            if let index = sortData.firstIndex(of: selectedSort) {
               print("Index of \(selectedSort) is \(index)")
                selectedIndex = index
            }
        }
        
   
        let disocuntTitle = sortData[safe: 0] ?? ""
        var discountFilter = FiltersCollectionViewCellRevampModel(name: disocuntTitle, leftImage: "", rightImage: "", isFilterSelected: selectedIndex == 0 ? true : false, rightImageWidth: 0, rightImageHeight: 4, tag: SortingCategoriesTypes.discount.rawValue)
        let discountFilterRowWidth = AppCommonMethods.getAutoWidthWith(discountFilter.name, fontTextStyle: .smilesTitle1, additionalWidth: 40)
        discountFilter.rowWidth = discountFilterRowWidth
        
        
        let cashVoucherTitle = sortData[safe: 1] ?? ""
        var cashVoucherFilter = FiltersCollectionViewCellRevampModel(name: cashVoucherTitle, leftImage: "", rightImage: "", isFilterSelected: selectedIndex == 1 ? true : false, rightImageWidth: 0, rightImageHeight: 4, tag: SortingCategoriesTypes.cashVoucher.rawValue)
        let cashVoucherFilterRowWidth = AppCommonMethods.getAutoWidthWith(cashVoucherFilter.name, fontTextStyle: .smilesTitle1, additionalWidth: 40)
        cashVoucherFilter.rowWidth = cashVoucherFilterRowWidth
        
        
        let dealVoucherTitle = sortData[safe: 2] ?? ""
        var dealVoucherFilter = FiltersCollectionViewCellRevampModel(name: dealVoucherTitle, leftImage: "", rightImage: "", isFilterSelected: selectedIndex == 2 ? true : false, rightImageWidth: 0, rightImageHeight: 4, tag: SortingCategoriesTypes.dealVoucher.rawValue)
        let dealVoucherFilterRowWidth = AppCommonMethods.getAutoWidthWith(dealVoucherFilter.name, fontTextStyle: .smilesTitle1, additionalWidth: 40)
        dealVoucherFilter.rowWidth = dealVoucherFilterRowWidth
        
        
        if isFilterAllowed != 0 {
            filters.append(firstFilter)
        }
        
        if isSortAllowed != 0 {
            guard let categoryId = categoryId else {return}
            if categoryId == 9{
                filters.append(discountFilter)
                filters.append(cashVoucherFilter)
                filters.append(dealVoucherFilter)
            }else{
                filters.append(secondFilter)
            }
            
        }
        
        if let appliedFilters = filtersSavedList, appliedFilters.count > 0 {
            for filter in appliedFilters {
                
                let width = AppCommonMethods.getAutoWidthWith(filter.filterName.asStringOrEmpty(), fontTextStyle: .smilesTitle1, additionalWidth: 40)
                
                let model = FiltersCollectionViewCellRevampModel(name: filter.filterName.asStringOrEmpty(), leftImage: "", rightImage: "filters-cross", isFilterSelected: true, filterValue: filter.filterValue.asStringOrEmpty(), tag: 0, rowWidth: width)

                filters.append(model)

            }
        }
        
        self.output.send(.fetchFiltersDataSuccess(filters: filters, selectedSortingTableViewCellModel: self.selectedSortingTableViewCellModel)) // Send filters back to VC
    }
    
    // Get saved filters
    func getSavedFilters() -> [RestaurantRequestFilter] {
        if let savedFilters = UserDefaults.standard.object([RestaurantRequestWithNameFilter].self, with: FilterDictTags.FiltersDict.rawValue) {
            if savedFilters.count > 0 {
                let uniqueUnordered = Array(Set(savedFilters))
                
                filtersSavedList = uniqueUnordered
                
                filtersList = [RestaurantRequestFilter]()
                
                if let savedFilters = filtersSavedList {
                    for filter in savedFilters {
                        let restaurantRequestFilter = RestaurantRequestFilter()
                        restaurantRequestFilter.filterKey = filter.filterKey
                        restaurantRequestFilter.filterValue = filter.filterValue
                        
                        filtersList?.append(restaurantRequestFilter)
                    }
                }
                
                defer {
                    self.output.send(.fetchSavedFiltersAfterSuccess(filtersSavedList: filtersSavedList ?? []))
                }

                return filtersList ?? []
                
            }
        }
        return []
    }
    
    func removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel) {
        // Remove all saved Filters
        let isFilteredIndex = filtersSavedList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.name.lowercased() == restaurantRequestWithNameFilter.filterName?.lowercased()
        })
        
        if let isFilteredIndex = isFilteredIndex {
            filtersSavedList?.remove(at: isFilteredIndex)
        }
        
        // Remove Names for filters
        let isFilteredNameIndex = filtersList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.filterValue.lowercased() == restaurantRequestWithNameFilter.filterValue?.lowercased()
        })
        
        if let isFilteredNameIndex = isFilteredNameIndex {
            filtersList?.remove(at: isFilteredNameIndex)
        }
        
        self.output.send(.emptyOffersListDidSucceed)
        self.output.send(.fetchAllSavedFiltersSuccess(filtersList: filtersList ?? [], filtersSavedList: filtersSavedList ?? []))
    }
    
    func generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?) {
        var items = [BaseRowModel]()
        
        if let sortingList = sortingModel?.sortingList, sortingList.count > 0 {
            for (index, sorting) in sortingList.enumerated() {
                if let sortingModel = selectedSortingTableViewCellModel {
                    if sortingModel.name?.lowercased() == sorting.name?.lowercased() {
                        if index == sortingList.count - 1 {
                            addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: true)
                        } else {
                            addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: false)
                        }
                    } else {
                        if index == sortingList.count - 1 {
                            addSortingItems(items: &items, sorting: sorting, isSelected: false, isBottomLineHidden: true)
                        } else {
                            addSortingItems(items: &items, sorting: sorting, isSelected: false, isBottomLineHidden: false)
                        }
                    }
                } else {
                    selectedSortingTableViewCellModel = FilterDO()
                    selectedSortingTableViewCellModel = sorting
                    if index == sortingList.count - 1 {
                        addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: true)
                    } else {
                        addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: false)
                    }
                }
            }
        }
        
        self.output.send(.fetchContentForSortingItems(baseRowModels: items))
    }
    
    func addSortingItems(items: inout [BaseRowModel], sorting: FilterDO, isSelected: Bool, isBottomLineHidden: Bool) {
        items.append(SortingTableViewCell.rowModel(model: SortingTableViewCellModel(title: sorting.name.asStringOrEmpty(), mode: .SingleSelection, isSelected: isSelected, multiChoiceUpTo: 1, isSelectionMandatory: true, sortingModel: sorting, bottomLineHidden: isBottomLineHidden)))
    }
}

// MARK: - Filters Delegate

//extension CategoryDetailsViewModel: RestaurantFiltersDelegate {
//    func didReturnRestaurantFilters(_ restaurantFilters: [RestaurantRequestWithNameFilter]) {
//        
//        self.filtersSavedList = []
//        
//        self.filtersSavedList = restaurantFilters
//        
//        var restaurantFiltersObjects = [RestaurantRequestFilter]()
//        for filter in restaurantFilters {
//            let restaurantRequestFilter = RestaurantRequestFilter()
//            restaurantRequestFilter.filterKey = filter.filterKey
//            restaurantRequestFilter.filterValue = filter.filterValue
//            restaurantFiltersObjects.append(restaurantRequestFilter)
//        }
//       
//        self.output.send(.fetchSavedFiltersAfterSuccess(filtersSavedList: self.filtersSavedList ?? []))
////        self.output.send(.emptyRestaurantListDidSucceed)
////        self.restaurantListUseCaseInput.send(.getRestaurantList(pageNo: 0, filtersList: restaurantFiltersObjects))
//    }
//}

// MARK: - Sorting Delegate

//extension CategoryDetailsViewModel: RestaurantSortingChoicesDelegate {
//    func didReturnSortParam(_ sortBy: FilterDO) {
//        setSelectedSortingParam(sort: sortBy)
//    }
//    
//    func setSelectedSortingParam(sort: FilterDO) {
//        selectedSortingTableViewCellModel = sort
//                
////        let restaurantRequestFilter = RestaurantRequestFilter()
////        restaurantRequestFilter.filterKey = sort.filterKey
////        restaurantRequestFilter.filterValue = sort.filterValue
////        self.output.send(.emptyRestaurantListDidSucceed)
////        self.restaurantListUseCaseInput.send(.getRestaurantList(pageNo: 0, filtersList: [restaurantRequestFilter]))
//    }
//}

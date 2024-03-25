//
//  CategoryDetailsViewController.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 21/12/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import Combine
import SmilesStoriesManager
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers
import SmilesBanners
import SmilesPersonalizationEvent
import SmilesLoader
import SmilesFilterAndSort
import SmilesReusableComponents

enum OfferSort: String, CaseIterable {
    case discount = "Discounts"
    case voucher = "Vouchers"
    case dealVouchers = "DealVouchers"
}

public class CategoryDetailsViewController: UIViewController, SmilesCoordinatorBoards {
    var didScroll:(UIScrollView)->Void = {_ in}
    
    // MARK: -- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -- Variables
    let input: PassthroughSubject<CategoryDetailsViewModel.Input, Never> = .init()
    private let viewModel = CategoryDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var dataSource: SectionedTableViewDataSource?
    var categoryDetailsSections: GetSectionsResponseModel?
    var sections = [TableSectionData<SectionIdentifier>]()
    
    var categoryId = 0
    var subCategoryId: Int?
    var offersCategoryId = 0
    var themeId:Int? = nil
    var sortOfferBy: String?
    var sortingType: String?
    var lastSortCriteria: String?
    var arraySelectedSubCategoryTypes: [String] = []
    
    private var selectedIndexPath: IndexPath?
    private var offerFavoriteOperation = 0 // Operation 1 = add and Operation 2 = remove
    
    var offersListing: OffersCategoryResponseModel?
    var offersPage = 1 // For offers list pagination
    var dodOffersPage = 1 // For DOD offers list pagination
    var offers = [OfferDO]()
    var dodOffers = [OfferDO]()
    
    var filtersSavedList: [RestaurantRequestWithNameFilter]?
    var savedFilters: [RestaurantRequestFilter]?
    var filtersData: [FiltersCollectionViewCellRevampModel]?
    var selectedSortingTableViewCellModel: FilterDO?
    var sortingListRowModels: [BaseRowModel]?
    
    var selectedSortTypeIndex: Int?
    var didSelectFilterOrSort = false
    var isFromViewAll: Bool?
    var mutatingSectionDetails = [SectionDetailDO]()
    var consentConfigList: [ConsentConfigDO]?
    var personalizationEventSource: String?
    
    var selectedSortIndex = -1
    var pageSheetView: PageSheetView!
    var redirectionURL: String?
    var consentActionType: ConsentActionType?
    
    var selectedFiltersResponse: Data?
    weak var delegate: SmilesCategoriesDelegate?
    private var dependencies: SmilesCategoryDetailsDependencies?
    
    public func initialiser(dependencies: SmilesCategoryDetailsDependencies) {
        
        self.dependencies = dependencies
        self.delegate = dependencies.delegate
        self.consentConfigList = dependencies.consentConfigList
        self.categoryId = dependencies.categoryId ?? 0
        self.themeId = dependencies.themeId
        self.subCategoryId = dependencies.subCategoryId
        self.didScroll = dependencies.didScroll
        self.isFromViewAll = dependencies.isFromViewAll
        self.personalizationEventSource = dependencies.personalizationEventSource
        
    }
    
   
    
    // MARK: -- View LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let subCategoryId {
            arraySelectedSubCategoryTypes = ["\(subCategoryId)"]
        }
        bind(to: viewModel)
        setPersonalizationEventSource()
        setupTableView()
        callCategoryDetailsServices()
        
        OrderInfoModel.shared.orderTypeDefaultValue = .DELIVERY
        if let sortBy = self.sortOfferBy, !sortBy.isEmpty {
            self.sortingType = sortBy
        }
        
        offersCategoryId = ((self.categoryId == 21) || (self.categoryId == 22)) ? 9 : self.categoryId
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.currentPresentedViewController(viewController: self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: -- Binding
    
    func bind(to viewModel: CategoryDetailsViewModel) {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                    // MARK: - Success cases
                    // Section Details Success
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchCuisinesDidSucceed(let cuisinesResponse):
                    self?.configureCuisinesData(with: cuisinesResponse)
                    
                    // Top Brands Success
                case .fetchTopBrandsDidSucceed(let topBrandsResponse):
                    self?.configureTopBrandsData(with: topBrandsResponse)
                    
                    // Collections Success
                case .fetchCollectionsDidSucceed(let collectionsResponse):
                    self?.configureCollectionsData(with: collectionsResponse)
                    
                    // Stories Success
                case .fetchStoriesDidSucceed(let storiesResponse):
                    self?.configureStoriesData(with: storiesResponse)
                    break
                    // Subscription Success
                case .fetchSubscriptionBannerDidSucceed(let subscriptionBannerResponse):
                    
                    self?.configureBannersData(with: subscriptionBannerResponse, sectionIdentifier: SectionIdentifier(rawValue: subscriptionBannerResponse.bannerSubType ?? "") ?? .SUBSCRIPTIONBANNERS)
                    
                case .routeToRestaurantDetailDidSucceed(let selectedRestarant, let isViewCart):
                    self?.redirectToRestaurantDetailController(restaurant: selectedRestarant, isViewCart: isViewCart ?? false)
                    
                case .fetchItemCategoriesDidSucceed(let itemCategoriesResponse):
                    self?.configureItemCategoriesData(with: itemCategoriesResponse)
                    
                case .fetchTopOffersDidSucceed(let topOffersResponse):
                    self?.configureBannersData(with: topOffersResponse, sectionIdentifier: .TOPBANNERS)
                case .fetchNearbyOffersDidSucceed(let nearbyOffersResponse):
                    self?.configureNearbyOffersData(with: nearbyOffersResponse)
                    
                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
                    self?.configureWishListData(with: updateWishlistResponse)
                    
                case .fetchOffersCategoryListDidSucceed(let offersCategoryListResponse):
                    self?.configureOffersCategoryListData(with: offersCategoryListResponse)
                    
                    // Popular Restaurants Success
                case .fetchPopularRestaurantsDidSucceed(let popularRestaurantsResponse, let menuItemType):
                    if menuItemType == nil {
                        self?.delegate?.presentRestaurantsList(response: popularRestaurantsResponse, onRestaurantPicked: { restaurant in
                            self?.delegate?.navigateToRestaurantDetailVC(restaurant: restaurant, isViewCart: false, recommendationModelEvent: "", personalizationEventSource: self?.personalizationEventSource)
                        })
                    } else {
                        self?.configurePopularRestaurantsData(with: popularRestaurantsResponse)
                    }
                    
                    // Filters Data Binding
                case .fetchOffersFiltersDidSucceed(let offersFiltersResponse):
                    debugPrint(offersFiltersResponse)
                    
                case .fetchFiltersDataSuccess(let filters, let selectedSortingTableViewCellModel):
                    self?.filtersData = filters
                    self?.selectedSortingTableViewCellModel = selectedSortingTableViewCellModel
                    break
                case .fetchAllSavedFiltersSuccess(let filtersList, let savedFilters):
                    self?.savedFilters = filtersList
                    self?.filtersSavedList = savedFilters
                    self?.offers.removeAll()
                    self?.configureDataSource()
                    self?.configureFiltersData()
                    
                case .fetchSavedFiltersAfterSuccess(let filtersSavedList):
                    self?.filtersSavedList = filtersSavedList
                    
                case .fetchSortingListDidSucceed:
                    self?.configureSortingData()
                    
                case .fetchContentForSortingItems(let baseRowModels):
                    self?.sortingListRowModels = baseRowModels
                    
                case .emptyOffersListDidSucceed:
                    self?.offersPage = 1
                    self?.offers.removeAll()
                    self?.configureDataSource()
                    
                case .fetchCBDDetailsDidSucceed(response: let response):
                    self?.configureCBDDetailsData(with: response)
                    
                case .updateSortingWithSelectedSort(let sortBy):
                    self?.updateOfferListing(withSortBy: sortBy)
                    
                    
                    // MARK: - Failure cases
                    
                case .fetchSectionsDidFail(error: let error):
                    print(error.localizedDescription)
                    
                case .fetchTopBrandsDidFail(error: let error):
                    print(error.localizedDescription)
                    self?.configureHideSection(for: .TOPBRANDS, dataSource: GetTopBrandsResponseModel.self)
                    
                case .fetchCollectionDidFail(error: let error):
                    print(error.localizedDescription)
                    self?.configureHideSection(for: .TOPCOLLECTIONS, dataSource: GetCollectionsResponseModel.self)
                    
                case .fetchDidFail(error: let error):
                    print(error.localizedDescription)
                    self?.configureHideSection(for: .STORIES, dataSource: Stories.self)
                    
                case .fetchSubscriptionBannerDidFail(let error):
                    print(error.localizedDescription)
                    self?.configureHideSection(for: .SUBSCRIPTIONBANNERS, dataSource: GetSubscriptionBannerResponseModel.self)
                    
                case .fetchCuisinesDidFail(let error):
                    print(error.localizedDescription)
                    self?.configureHideSection(for: .TOPCUISINE, dataSource: GetCuisinesResponseModel.self)
                    
                case .fetchItemCategoriesDidFail(let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .ITEMCATEGORIES, dataSource: ItemCategoriesResponseModel.self)
                    
                case .fetchTopOffersDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .TOPBANNERS, dataSource: GetTopOffersResponseModel.self)
                    
                case .fetchNearbyOffersDidFail(let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .DODLISTING, dataSource: [OfferDO].self)
                    
                case .fetchOffersCategoryListDidFail(let error):
                    SmilesLoader.dismiss()
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .OFFERLISTING, dataSource: [OfferDO].self)
                    
                case .fetchPopularRestaurantsDidFail(let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .RECOMMENDEDLISTING, dataSource: GetPopularRestaurantsResponseModel.self)
                    
                case .fetchOffersFiltersDidFail(let error):
                    debugPrint(error.localizedDescription)
                case .fetchCBDDetailsDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                }
            }.store(in: &cancellables)
    }
    
    // MARK: -- Class Methods
    
    func callCategoryDetailsServices() {
        self.input.send(.getSections(categoryID: self.categoryId, subCategoryId: subCategoryId))
    }
    
    func categoryDetailsAPICalls() {
        if let sectionDetails = self.categoryDetailsSections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                
                if let section = SectionIdentifier(rawValue: sectionIdentifier), section  != .TOPPLACEHOLDER {
                    sections.append(TableSectionData(index: index, identifier: section))
                }
                switch SectionIdentifier(rawValue: sectionIdentifier) {
                case .ORDERHISTORY:
                    break
                    
                case .TOPBANNERS:
                    if let response = GetTopOffersResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forTopOffers: response, data:"#FFFFFF", isDummy: true, completion:nil)
                    }
                    self.input.send(.getTopOffers(menuItemType: nil, bannerType: "HOME", categoryId: self.categoryId, bannerSubType: "TOP_BANNERS"))
                    
                case .ITEMCATEGORIES:
                    if let response = ItemCategoriesResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forItemCategories: response, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getItemCategories)
                    
                case .GAMIFICATIONBANNER:
                    break
                    
                case .TOPCUISINE:
                    if let response = GetCuisinesResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forCuisines: response, data:"#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getCuisines(categoryID: self.categoryId, menuItemType: "HOME"))
                case .RECOMMENDEDLISTING:
                    if let response = GetPopularRestaurantsResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forPopularResturants: response, data:"#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getPopularRestaurants(menuItemType: OrderInfoModel.shared.orderTypeDefaultValue.rawValue))
                case .TOPCOLLECTIONS:
                    if let response = GetCollectionsResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forCollections: response, data:"#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getCollections(categoryID: self.categoryId, menuItemType: nil))
                case .STORIES:
                    if let stories = Stories.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forStories: stories, data:"#FFFFFF", isDummy:true, onClick: nil)
                    }
                    self.input.send(.getStories(categoryID: element.categoryId ?? -1))
                case .DODLISTING:
                    if let nearbyOffers = [OfferDO].fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forNearbyOffers: nearbyOffers, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getNearbyOffers(pageNo: 1))
                case .TOPBRANDS:
                    if let response = GetTopBrandsResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forBrands: response, data:"#FFFFFF", isDummy: true, topBrandsType: .foodOrder, completion: nil)
                    }
                    self.input.send(.getTopBrands(categoryID: self.categoryId, menuItemType: nil))
                case .SUBSCRIPTIONBANNERS:
                    if let response = GetTopOffersResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forTopOffers: response, data:"#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getSubscriptionBanner(menuItemType: nil, bannerType: "HOME", categoryId: self.categoryId, bannerSubType: "SUBSCRIPTION_BANNERS"))
                case .SUBSCRIPTIONBANNERSV2:
                    if let response = GetTopOffersResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.makeSubscription(forTopOffers: response, data:"#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getSubscriptionBanner(menuItemType: nil, bannerType: "HOME", categoryId: nil, bannerSubType: "SUBSCRIPTION_BANNERS_V2"))
                case .OFFERLISTING:
                    showShimmer(identifier: .OFFERLISTING)
                    self.input.send(.getOffersCategoryList(pageNo: 1, categoryId: "\(self.offersCategoryId)", searchByLocation: false, sortingType: sortingType, subCategoryTypeIdsList: arraySelectedSubCategoryTypes, themeId: (themeId != nil) ? "\(self.themeId!)" : nil))
                    
                    self.input.send(.getSortingList)
                case .CBDBANNER:
                    getCBDCreditCardFromWebService()
                default:
                    break
                }
            }
            
            OperationQueue.main.addOperation{
                self.tableView.reloadData()
            }
        }
    }
    func getCBDCreditCardFromWebService(){
        if let notEligibleObj =  GetEligibilityMatrixResponse.sharedInstance.notEligibleObject, !notEligibleObj.cbdAcquisition{
            input.send(.getCBDDetails)
        }
    }
    // MARK: - Helping Functions
    
    func setupTableView() {
        self.tableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = CGFloat(0)
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        
        let customizable: CellRegisterable? = CategoryDetailsCellRegistration()
        customizable?.register(for: self.tableView)
        
        // ----- Tableview section header hide in case of tableview mode Plain ---
        let dummyViewHeight = CGFloat(150)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        // ----- Tableview section header hide in case of tableview mode Plain ---
    }
    
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getSectionIndex(for identifier: SectionIdentifier) -> Int? {
        
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
        
    }
    
    func updateOfferWishlistStatus(isFavorite: Bool, offerId: String) {
        offerFavoriteOperation = isFavorite ? 1 : 2
        input.send(.updateOfferWishlistStatus(operation: offerFavoriteOperation, offerId: offerId))
    }
}

// MARK: - Configurations

extension CategoryDetailsViewController {
    func addCBDSection(){
        var cbdSec = SectionDetailDO()
        cbdSec.backgroundColor = "#FFFFFF"
        cbdSec.sectionIdentifier = SectionIdentifier.CBDBANNER.rawValue
        self.categoryDetailsSections?.sectionDetails?.insert(cbdSec, at: 0)
    }
    fileprivate func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        self.categoryDetailsSections = sectionsResponse
        if let index = self.categoryDetailsSections?.sectionDetails?.firstIndex(where: { $0.sectionIdentifier == SectionIdentifier.TOPPLACEHOLDER.rawValue }) {
            self.categoryDetailsSections?.sectionDetails?.remove(at: index)
        }
        //enable if needed CBD Section
        //        addCBDSection()
        
        self.mutatingSectionDetails = self.categoryDetailsSections?.sectionDetails ?? []
        
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        
        if let parentViewController = self.parent as? CategoryContainerViewController, let topPlaceHolderResponse = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == SectionIdentifier.TOPPLACEHOLDER.rawValue }) {
            if categoryId == 8 && !parentViewController.shouldAddBillsController {
                parentViewController.headerTitle = "Etisalat Bundle".localizedString
                parentViewController.topHeaderView.setHeaderTitle(title: "Etisalat Bundle".localizedString)
            } else {
                if let title = topPlaceHolderResponse.title {
                    parentViewController.headerTitle = title
                    parentViewController.topHeaderView.setHeaderTitle(title: title)
                }
            }
            
            if let iconURL = topPlaceHolderResponse.iconUrl {
                parentViewController.topHeaderView.headerTitleImageView.isHidden = false
                parentViewController.topHeaderView.setHeaderTitleIcon(iconURL: iconURL)
            }
            
            if let searchTag = topPlaceHolderResponse.searchTag {
                parentViewController.topHeaderView.setSearchText(with: searchTag)
            }
        }
        
        _ = TableViewDataSource.make(forSections: sectionsResponse, data: "", completion: nil)
        self.configureDataSource()
        self.categoryDetailsAPICalls()
    }
    
    fileprivate func configureTopBrandsData(with topBrandsResponse: GetTopBrandsResponseModel) {
        if let brands = topBrandsResponse.brands, !brands.isEmpty {
            if let topBrandsIndex = getSectionIndex(for: .TOPBRANDS) {
                self.dataSource?.dataSources?[topBrandsIndex] = TableViewDataSource.make(forBrands: topBrandsResponse, data: self.categoryDetailsSections?.sectionDetails?[topBrandsIndex].backgroundColor ?? "#FFFFFF", topBrandsType: .foodOrder, completion: { [weak self] data in
                    self?.delegate?.smilesCategoriesAnalytics(event: .ClickOnTopBrands, parameters: [:])
                    if let eventName = self?.categoryDetailsSections?.getEventName(for: SectionIdentifier.TOPBRANDS.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, urlScheme: data.redirectionUrl.asStringOrEmpty(), offerId: data.id, source: self?.personalizationEventSource)
                    }
                    
                    if let urlScheme = AppCommonMethods.getSchemeFromUrl(urlString: data.redirectionUrl), !urlScheme.contains("smiles") {
                        if let topBrandsConsent = self?.dependencies?.consentConfigList?.first(where: {$0.consentType == .topBrand}) {
                            self?.redirectionURL = data.redirectionUrl ?? ""
                            self?.presentPageSheet(withConsentConfig: topBrandsConsent)
                        }
                        
                    } else {
                        self?.handleBannerDeepLinkRedirections(url: data.redirectionUrl.asStringOrEmpty())
                    }
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .TOPBRANDS, dataSource: GetTopBrandsResponseModel.self)
        }
    }
    
    fileprivate func configureCollectionsData(with collectionsResponse: GetCollectionsResponseModel) {
        if let collections = collectionsResponse.collections, !collections.isEmpty {
            if let topCollectionsIndex = getSectionIndex(for: .TOPCOLLECTIONS) {
                self.dataSource?.dataSources?[topCollectionsIndex] = TableViewDataSource.make(forCollections: collectionsResponse, data: self.categoryDetailsSections?.sectionDetails?[topCollectionsIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] data in
                    
                    if let eventName = self?.categoryDetailsSections?.getEventName(for: SectionIdentifier.TOPCOLLECTIONS.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, urlScheme: data.redirectionUrl.asStringOrEmpty(), offerId: data.id, source: self?.personalizationEventSource)
                    }
                    self?.handleBannerDeepLinkRedirections(url: data.redirectionUrl.asStringOrEmpty())
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .TOPCOLLECTIONS, dataSource: GetCollectionsResponseModel.self)
        }
    }
    
    fileprivate func configureStoriesData(with storiesResponse: Stories) {
        if let stories = storiesResponse.stories, !stories.isEmpty {
            if let storiesIndex = getSectionIndex(for: .STORIES) {
                self.dataSource?.dataSources?[storiesIndex] = TableViewDataSource.make(forStories: storiesResponse, data: self.categoryDetailsSections?.sectionDetails?[storiesIndex].backgroundColor ?? "#FFFFFF", onClick: { [weak self] story in
                    if var stories = ((self?.dataSource?.dataSources?[safe: storiesIndex] as? TableViewDataSource<Stories>)?.models)?.first {
                        self?.delegate?.smilesCategoriesAnalytics(event: .ClickOnStory, parameters: [:])
                        
                        if let eventName = self?.categoryDetailsSections?.getEventName(for: SectionIdentifier.STORIES.rawValue), !eventName.isEmpty {
                            PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, offerId: story.storyID.asStringOrEmpty(), source: self?.personalizationEventSource)
                        }
                        
                        self?.openStories(stories: stories.stories ?? [], storyIndex: stories.stories?.firstIndex(of: story) ?? 0){storyIndex,snapIndex,isFavorite in
                            stories.setFavourite(isFavorite: isFavorite, storyIndex: storyIndex, snapIndex: snapIndex)
                            (self?.dataSource?.dataSources?[safe: storiesIndex] as? TableViewDataSource<Stories>)?.models = [stories]
                        }
                    }
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .STORIES, dataSource: Stories.self)
        }
    }
    
    fileprivate func configureSubscriptionBannerData(with subscriptionBannerResponse: GetSubscriptionBannerResponseModel) {
        if let subscriptionBanner = subscriptionBannerResponse.subscriptionBanner, let imageUrl = subscriptionBanner.subscriptionImage, !imageUrl.isEmpty {
            if let index = getSectionIndex(for: .SUBSCRIPTIONBANNERS) {
                self.dataSource?.dataSources?[index] = TableViewDataSource.make(forSubscription: subscriptionBannerResponse, data: self.categoryDetailsSections?.sectionDetails?[index].backgroundColor ?? "#FFFFFF")
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .SUBSCRIPTIONBANNERS, dataSource: GetSubscriptionBannerResponseModel.self)
        }
    }
    
    fileprivate func configureCuisinesData(with cuisinesResponse: GetCuisinesResponseModel) {
        if let cuisines = cuisinesResponse.cuisines, !cuisines.isEmpty {
            if let cuisineIndex = getSectionIndex(for: .TOPCUISINE) {
                self.dataSource?.dataSources?[cuisineIndex] = TableViewDataSource.make(forCuisines: cuisinesResponse, data: self.categoryDetailsSections?.sectionDetails?[cuisineIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] data in
                    
                    if let eventName = self?.categoryDetailsSections?.getEventName(for: SectionIdentifier.TOPCUISINE.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, urlScheme: data.redirectionUrl.asStringOrEmpty(), cuisineName: data.title.asStringOrEmpty(), source: self?.personalizationEventSource)
                    }
                    self?.handleBannerDeepLinkRedirections(url: data.redirectionUrl.asStringOrEmpty())
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .TOPCUISINE, dataSource: GetCuisinesResponseModel.self)
        }
    }
    
    fileprivate func configureItemCategoriesData(with itemCategoriesResponse: ItemCategoriesResponseModel) {
        if let itemCategories = itemCategoriesResponse.itemCategoriesDetails, !itemCategories.isEmpty {
            if let itemCategoryIndex = getSectionIndex(for: .ITEMCATEGORIES) {
                self.dataSource?.dataSources?[itemCategoryIndex] = TableViewDataSource.make(forItemCategories: itemCategoriesResponse, data: self.categoryDetailsSections?.sectionDetails?[itemCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] data in
                    
                    if let eventName = self?.categoryDetailsSections?.getEventName(for: SectionIdentifier.ITEMCATEGORIES.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, urlScheme: data.redirectionUrl.asStringOrEmpty(), offerId: String(data.categoryId ?? 0), source: self?.personalizationEventSource)
                    }
                    
                    if data.redirectionUrl?.contains("exploreall") ?? false {
                        self?.presentCategoriesPicker(groups:data.groupItemCategoriesDetails ?? [])
                    } else {
                        self?.handleBannerDeepLinkRedirections(url: "\(data.redirectionUrl.asStringOrEmpty())/\(data.categoryId ?? 0)")
                    }
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .ITEMCATEGORIES, dataSource: ItemCategoriesResponseModel.self)
        }
    }
    
    fileprivate func configureBannersData(with offersResponse: GetTopOffersResponseModel, sectionIdentifier: SectionIdentifier) {
        
        if let ads = offersResponse.ads, !ads.isEmpty {
            if let offersIndex = getSectionIndex(for: sectionIdentifier) {
                if (sectionIdentifier != .SUBSCRIPTIONBANNERSV2) {
                    self.dataSource?.dataSources?[offersIndex] = TableViewDataSource.make(forTopOffers: offersResponse, data: self.categoryDetailsSections?.sectionDetails?[offersIndex].backgroundColor ?? "#FFFFFF", completion:{ [weak self] data in
                        
                        if let eventName = self?.categoryDetailsSections?.getEventName(for: sectionIdentifier.rawValue), !eventName.isEmpty {
                            self?.registerBannerEvent(eventName: eventName, bannerType: sectionIdentifier == .TOPBANNERS ? "top" : "bottom", urlScheme: data.externalWebUrl.asStringOrEmpty(), id: String(data.adId ?? 0))
                        }
                        self?.handleBannerDeepLinkRedirections(url: data.externalWebUrl.asStringOrEmpty())
                    })
                } else
                {
                    self.dataSource?.dataSources?[offersIndex] = TableViewDataSource.makeSubscription(forTopOffers: offersResponse, data: self.categoryDetailsSections?.sectionDetails?[offersIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] data in
                        
                        if let eventName = self?.categoryDetailsSections?.getEventName(for: sectionIdentifier.rawValue), !eventName.isEmpty {
                            self?.registerBannerEvent(eventName: eventName, bannerType: sectionIdentifier == .TOPBANNERS ? "top" : "bottom", urlScheme: data.externalWebUrl.asStringOrEmpty(), id: String(data.adId ?? 0))
                        }
                        self?.handleBannerDeepLinkRedirections(url: data.externalWebUrl.asStringOrEmpty())
                    })
                    
                }
            }
            
            configureDataSource()
        } else {
            self.configureHideSection(for: sectionIdentifier, dataSource: GetTopOffersResponseModel.self)
        }
    }
    
    private func registerBannerEvent(eventName: String, bannerType: String, urlScheme: String, id: String) {
        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, urlScheme: urlScheme, offerId: id, bannerType: bannerType, source: self.personalizationEventSource)
    }
    
    fileprivate func configureNearbyOffersData(with nearbyOffersResponse: NearbyOffersResponseModel) {
        if let umOffers = nearbyOffersResponse.umOffers, !umOffers.isEmpty {
            dodOffers.append(contentsOf: umOffers)
            if let nearbyOfferIndex = getSectionIndex(for: .DODLISTING) {
                self.dataSource?.dataSources?[nearbyOfferIndex] = TableViewDataSource.make(forNearbyOffers: dodOffers, data: self.categoryDetailsSections?.sectionDetails?[nearbyOfferIndex].backgroundColor ?? "#FFFFFF"
                ) { [weak self] isFavorite, offerId, indexPath in
                    self?.selectedIndexPath = indexPath
                    if !AppCommonMethods.isGuestUser {
                        self?.updateOfferWishlistStatus(isFavorite: isFavorite, offerId: offerId)
                    } else {
                        self?.delegate?.showGuestUserLoginPopUp()
                    }
                }
                self.configureDataSource()
            }
        } else {
            guard dodOffers.isEmpty else {return}
            self.configureHideSection(for: .DODLISTING, dataSource: OfferDO.self)
        }
    }
    
    fileprivate func configureWishListData(with updateWishlistResponse: WishListResponseModel) {
        var isFavoriteOffer = false
        
        if let favoriteIndexPath = self.selectedIndexPath {
            if let updateWishlistStatus = updateWishlistResponse.updateWishlistStatus, updateWishlistStatus {
                isFavoriteOffer = self.offerFavoriteOperation == 1 ? true : false
            } else {
                isFavoriteOffer = false
            }
            
            (self.dataSource?.dataSources?[favoriteIndexPath.section] as? TableViewDataSource<OfferDO>)?.models?[favoriteIndexPath.row].isWishlisted = isFavoriteOffer
            
            if let cell = tableView.cellForRow(at: favoriteIndexPath) as? RestaurantsRevampTableViewCell {
                cell.offerData?.isWishlisted = isFavoriteOffer
                cell.showFavouriteAnimation(isRestaurant: false)
            }
            
        }
    }
    
    fileprivate func configureCBDDetailsData(with cbdDetailsResponse: CBDDetailsResponseModel) {
        if let index = getSectionIndex(for: .CBDBANNER){
            self.dataSource?.dataSources?[index] = TableViewDataSource.make(objects: [cbdDetailsResponse])
        }
        
        configureDataSource()
    }
    
    fileprivate func configureOffersCategoryListData(with offersCategoryListResponse: OffersCategoryResponseModel) {
        self.offersListing = offersCategoryListResponse
        tableView.tableFooterView = nil
        let offers = getAllOffers(offersCategoryListResponse: offersCategoryListResponse)
        if !offers.isEmpty {
            self.offers.append(contentsOf: offers)
            if let offersCategoryIndex = getSectionIndex(for: .OFFERLISTING) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forNearbyOffers: self.offers, offerCellType: .categoryDetails, data: self.categoryDetailsSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF"
                ) { [weak self] isFavorite, offerId, indexPath in
                    self?.selectedIndexPath = indexPath
                    if !AppCommonMethods.isGuestUser {
                        self?.updateOfferWishlistStatus(isFavorite: isFavorite, offerId: offerId)
                    } else {
                        self?.delegate?.showGuestUserLoginPopUp()
                    }
                }
                self.configureDataSource()
            }
        } else {
            if self.offers.isEmpty {
                if didSelectFilterOrSort {
                    if let offerListingIndex = getSectionIndex(for: .OFFERLISTING) {
                        self.dataSource?.dataSources?[offerListingIndex] = TableViewDataSource.make(forNoFilteredResultFound: NoFilteredResultCellModel(), data: "#FFFFFF")
                        
                        configureDataSource()
                        let sectionRect = tableView.rect(forSection: offerListingIndex)
                        tableView.setContentOffset(CGPoint(x: sectionRect.origin.x, y: sectionRect.origin.y), animated: true)
                    }
                } else {
                    self.configureHideSection(for: .OFFERLISTING, dataSource: OfferDO.self)
                }
            }
        }
    }
    
    private func getAllOffers(offersCategoryListResponse: OffersCategoryResponseModel) -> [OfferDO] {
        
        let featuredOffers = offersCategoryListResponse.featuredOffers?.map({ offer in
            var _offer = offer
            _offer.isFeatured = true
            return _offer
        })
        var offers = [OfferDO]()
        if self.offersPage == 1 {
            offers.append(contentsOf: featuredOffers ?? [])
        }
        offers.append(contentsOf: offersCategoryListResponse.offers ?? [])
        return offers
        
    }
    
    fileprivate func configurePopularRestaurantsData(with popularRestaurantsResponse: GetPopularRestaurantsResponseModel) {
        if let popularRestaurants = popularRestaurantsResponse.restaurants, !popularRestaurants.isEmpty {
            if let popularResturantsIndex = getSectionIndex(for: .RECOMMENDEDLISTING) {
                if let eventName = popularRestaurantsResponse.eventName, !eventName.isEmpty {
                    PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, menuItemType: "DELIVERY", source: self.personalizationEventSource)
                }
                
                self.dataSource?.dataSources?[popularResturantsIndex] = TableViewDataSource.make(forPopularResturants: popularRestaurantsResponse, data: self.categoryDetailsSections?.sectionDetails?[popularResturantsIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] data, _ in
                    
                    if let eventName = self?.categoryDetailsSections?.getEventName(for: SectionIdentifier.RECOMMENDEDLISTING.rawValue), !eventName.isEmpty {
                        PersonalizationEventHandler.shared.registerPersonalizationEvent(eventName: eventName, restaurantId: data.restaurantId.asStringOrEmpty(), menuItemType: "DELIVERY", recommendationModelEvent: data.recommendationModelEvent.asStringOrEmpty(), source: self?.personalizationEventSource)
                    }
                    self?.redirectToRestaurantDetailController(restaurant: data)
                })
                self.configureDataSource()
            }
        } else {
            self.configureHideSection(for: .RECOMMENDEDLISTING, dataSource: GetPopularRestaurantsResponseModel.self)
        }
    }
    func showShimmer(identifier:SectionIdentifier){
        if let sectionDetails = self.categoryDetailsSections?.sectionDetails, !sectionDetails.isEmpty {
            for (index, element) in sectionDetails.enumerated() {
                if let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty {
                    if SectionIdentifier(rawValue: sectionIdentifier) == identifier {
                        switch identifier{
                        case .OFFERLISTING:
                            if let offersCategory = OffersCategoryResponseModel.fromFile() {
                                self.dataSource?.dataSources?[index] = TableViewDataSource.make(forNearbyOffers: offersCategory.offers ?? [], data: "#FFFFFF", isDummy: true, completion: nil)
                            }
                            break
                        default:break//handle other cases if needed later
                        }
                    }
                }
            }
        }
    }
    fileprivate func configureSortingData() {
        guard let sortData = AppCommonMethods.getLocalizedArray(forKey: "ViewAllSortCriteria") as? [String] else { return }
        var filterDO = [FilterDO]()
        
        sortData.forEach {
            let filter = FilterDO()
            filter.name = $0
            filter.filterKey = "order_sort"
            
            filterDO.append(filter)
        }
        
        let sortingModel = GetSortingListResponseModel(sortingList: filterDO)
        self.input.send(.generateActionContentForSortingItems(sortingModel: sortingModel))
    }
    
    fileprivate func configureHideSection<T>(for section: SectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            self.mutatingSectionDetails.removeAll(where: { $0.sectionIdentifier == section.rawValue })
            
            self.configureDataSource()
        }
    }
    
    fileprivate func configureFiltersData() {
        if let filtersSavedList = self.filtersSavedList {
            arraySelectedSubCategoryTypes = []
            
            for filter in filtersSavedList {
                arraySelectedSubCategoryTypes.append(filter.filterValue ?? "")
            }
        }
        showShimmer(identifier: .OFFERLISTING)
        self.input.send(.getOffersCategoryList(pageNo: 1, categoryId: "\(self.offersCategoryId)", searchByLocation: false, sortingType: sortingType, subCategoryTypeIdsList: arraySelectedSubCategoryTypes, themeId: (themeId != nil) ? "\(self.themeId!)" : nil))
    }
    
    fileprivate func setPersonalizationEventSource() {
        if let source = SharedConstants.personalizationEventSource {
            self.personalizationEventSource = source
            SharedConstants.personalizationEventSource = nil
        }
    }
    
}

// MARK: - Redirections
extension CategoryDetailsViewController {
    
    func redirectToRestaurantDetailController(restaurant: Restaurant, isViewCart: Bool = false) {
        delegate?.navigateToRestaurantDetailVC(restaurant: restaurant, isViewCart: isViewCart, recommendationModelEvent: restaurant.recommendationModelEvent, personalizationEventSource: self.personalizationEventSource)
    }
    
    func handleBannerDeepLinkRedirections(url: String) {
        delegate?.handleBannerDeepLinkRedirections(url: url)
    }
    
    func openStories(stories: [Story], storyIndex:Int, favouriteUpdatedCallback: ((_ storyIndex:Int,_ snapIndex:Int,_ isFavourite:Bool) -> Void)? = nil) {
        delegate?.navigateToStoriesDetailVC(stories: stories, storyIndex: storyIndex, favouriteUpdatedCallback: favouriteUpdatedCallback)
    }
    
    func redirectToSearch() {
        //delegate?.navigateToGlobalSearchVC()
    }
    
    func presentCategoriesPicker(groups:[GroupItemCategoryDetails]){
        delegate?.presentCategoryPicker(groups: groups)
    }
    
    func redirectToCollectionsDetail(collectionID: String, type: CollectionDetailsType, title: String?, subtitle: String?, headerTitle: String?) {
        
    }
    
    func redirectToOfferDetail(offer: OfferDO, isFromDealsForYouSection: Bool) {
        delegate?.navigateToOfferDetail(offer: offer, isFromDealsForYouSection: isFromDealsForYouSection, personalizationEventSource: self.personalizationEventSource)
        
    }
    
    func redirectToRestaurantDetail(offer: OfferDO) {
        let restaurantObj = Restaurant()
        restaurantObj.restaurantId = offer.offerId
        delegate?.navigateToRestaurantDetailVC(restaurant: restaurantObj, isViewCart: false, recommendationModelEvent: offer.recommendationModelEvent, personalizationEventSource: self.personalizationEventSource)
    }
    
    func redirectToOffersFilters() {
        let selectedFilters = getSelectedFilters()
        if selectedFilters.isEmpty {
            selectedFiltersResponse = nil
        }
        delegate?.navigateToFiltersVC(categoryId: categoryId, sortingType: sortingType, previousFiltersResponse: selectedFiltersResponse, selectedFilters: selectedFilters, filterDelegate: self)
    }
    
    func redirectToSortingPopUp() {
        guard let sortData = AppCommonMethods.getLocalizedArray(forKey: "ViewAllSortCriteria") as? [String] else { return }
        let sorts = viewModel.mapSortObjects(sorts: sortData)
        delegate?.navigateToSortingVC(sorts: sorts, delegate: self)
    }
}

extension CategoryDetailsViewController: SelectedFiltersDelegate {
    public func didSetFilters(_ filters: [FilterValue]) {
        arraySelectedSubCategoryTypes.removeAll()
        filtersSavedList = []
        
        var filterObjects: [RestaurantRequestWithNameFilter] = []
        
        filters.forEach {
            arraySelectedSubCategoryTypes.append($0.filterKey ?? "")
            let filter = RestaurantRequestWithNameFilter()
            filter.filterName = $0.name
            filter.filterValue = $0.filterKey
            filter.indexPath = $0.indexPath
            filterObjects.append(filter)
        }
        
        filtersSavedList = filterObjects
        didSelectFilterOrSort = true
        input.send(.setFiltersSavedList(filtersSavedList: self.filtersSavedList, filtersList: []))
        input.send(.emptyOffersList)
        showShimmer(identifier: .OFFERLISTING)
        self.input.send(.getOffersCategoryList(pageNo: 1, categoryId: "\(self.offersCategoryId)", searchByLocation: false, sortingType: sortingType, subCategoryTypeIdsList: arraySelectedSubCategoryTypes, themeId: (themeId != nil) ? "\(self.themeId!)" : nil))
    }
    
    public func didSetFilterResponse(_ data: Data?) {
        selectedFiltersResponse = data
    }
    
    private func getSelectedFilters() -> [FilterValue] {
        var selectedFilters: [FilterValue] = []
        for item in (filtersSavedList ?? []) {
            var filter = FilterValue()
            filter.indexPath = item.indexPath
            selectedFilters.append(filter)
        }
        
        return selectedFilters
    }
}

extension CategoryDetailsViewController: SelectedSortDelegate {
    public func didSetSort(sortBy: FilterDO) {
        viewModel.setSelectedSortingParam(sort: sortBy)
        
        let sortName = sortBy.filterValue
        let sortIndex = Int(sortBy.filterKey ?? "0") ?? 0
        
        lastSortCriteria = sortName
        sortingType = sortName
        
        selectedSortTypeIndex = sortIndex
        updateTheOffersListingWithSelectedSort(sortIndex)
    }
}

extension CategoryDetailsViewController {
    func updateOfferListing(withSortBy:SortingCategoriesTypes) {
        var index = -1
        switch withSortBy {
        case .discount:
            self.lastSortCriteria = OfferSort.discount.rawValue
            self.sortingType = OfferSort.discount.rawValue
            index = 0
        case .cashVoucher:
            self.lastSortCriteria = OfferSort.voucher.rawValue
            self.sortingType = OfferSort.voucher.rawValue
            index = 1
        case .dealVoucher:
            self.lastSortCriteria = OfferSort.dealVouchers.rawValue
            self.sortingType = OfferSort.dealVouchers.rawValue
            index = 2
        }
        
        if selectedSortIndex != index {
            selectedSortIndex = index
            self.selectedSortTypeIndex = index
            updateTheOffersListingWithSelectedSort(index)
        }
    }
    
    func updateTheOffersListingWithSelectedSort(_ index: Int) {
        let sortData = AppCommonMethods.getLocalizedArray(forKey: "ViewAllSortCriteria") as? [String]
        let selectedSort = sortData?[index]
        
        self.didSelectFilterOrSort = true
        self.input.send(.setSelectedSort(sortTitle: selectedSort))
        self.input.send(.emptyOffersList)
        self.showShimmer(identifier: .OFFERLISTING)
        self.input.send(.getOffersCategoryList(pageNo: 1, categoryId: "\(self.offersCategoryId)", searchByLocation: false, sortingType: sortingType, subCategoryTypeIdsList: arraySelectedSubCategoryTypes, themeId: (themeId != nil) ? "\(self.themeId!)" : nil))
    }
}

// MARK: - ActionSheetButtonsDelegate
extension CategoryDetailsViewController {
    
    func presentPageSheet(withConsentConfig consent: ConsentConfigDO?) {
        
        pageSheetView = PageSheetView(delegate: self, pageSheetModel: consent)
        pageSheetView.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.view.addSubview(pageSheetView)
        // Configure constraints for the pageSheetView
        activateConstraints(subView: pageSheetView, superView: view)
        pageSheetView.updateContainerHeight()
    }
}

extension CategoryDetailsViewController: PageSheetDelegate {
    
    public func didSelectLeftButton() {
        pageSheetView.removeFromSuperview()
        self.consentActionType = nil
    }
    
    public func didSelectRightButton() {
        AppCommonMethods.openExternalUrl(urlString: redirectionURL.asStringOrEmpty()) { [weak self] _ in
            guard let self else { return }
            self.consentActionType = nil
        }
        pageSheetView.removeFromSuperview()
    }
    
}


@objc enum CollectionDetailsType: Int {
    case collection = 0
    case brands = 1
}

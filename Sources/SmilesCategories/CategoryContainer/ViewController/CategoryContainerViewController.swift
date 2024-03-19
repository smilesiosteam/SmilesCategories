//
//  CategoryContainerViewController.swift
//  House
//
//  Created by Shahroze Zaheer on 21/12/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import Combine
import SmilesSharedServices
import AppHeader
import SmilesUtilities
import AppHeader


public class CategoryContainerViewController: UIViewController, SmilesCoordinatorBoards {
    
    @IBOutlet public weak var topHeaderView: AppHeaderView!
    @IBOutlet public weak var containerView: UIView!
    // MARK: -- Variables
    private let input: PassthroughSubject<CategoryContainerViewModel.Input, Never> = .init()
    private let viewModel = CategoryContainerViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var categoryId: Int = 0
    var themeId: Int?
    var subCategoryId: Int?
    public var shouldAddBillsController: Bool = false
    var backToRootView: Bool?
    var headerTitle: String?
    var isFromViewAll: Bool?
    var isFromGifting = false
    var isFromSummary = false
    var isHeaderExpanding = false
    var personalizationEventSource: String?
    var isPayBillsView = true
    public var didLoadView: ((UIView) -> Void)?
    
    weak var delegate: SmilesCategoriesContainerDelegate?
    
    // MARK: -- View LifeCycle
    
    public func initialiser(dependencies: SmilesCategoryContainerDependencies) {
        
        delegate = dependencies.delegate
        categoryId = dependencies.categoryId ?? 0
        themeId = dependencies.themeId
        subCategoryId = dependencies.subCategoryId
        shouldAddBillsController = dependencies.shouldAddBillsController ?? false
        isFromViewAll = dependencies.isFromViewAll
        isFromGifting = dependencies.isFromGifting ?? false
        isFromSummary = dependencies.isFromSummary ?? false
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setPersonalizationEventSource()
        bind(to: viewModel)
        updateView(index: 0)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        didLoadView?(containerView)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHeaderView()
        delegate?.currentPresentedViewController(viewController: self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: -- Binding
    
    func bind(to viewModel: CategoryContainerViewModel) {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                    // MARK: - Success cases
                    // Section Details Success
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                    // MARK: - Failure cases
                    // Section Details Failure
                case .fetchSectionsDidFail(error: let error):
                    print(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
    private func setupHeaderView() {
        topHeaderView.delegate = self
        topHeaderView.setBackgroundColorForTabsCurveView(color: .systemBackground)
        topHeaderView.setupHeaderView(backgroundColor: .appRevampFilterCountBGColor.withAlphaComponent(0.1), searchBarColor: .white, pointsViewColor: .black.withAlphaComponent(0.1), titleColor: .black, headerTitle: self.headerTitle.asStringOrEmpty(), showHeaderNavigaton: true, topCurveShouldAdd: (shouldAddBillsController ? false : true), haveSearchBorder: true, isGuestUser: AppCommonMethods.isGuestUser)
        
        if shouldAddBillsController {
            topHeaderView.setBottomSegment(title1: "PayBill".localizedString, icon1: UIImage(named: "payBillIcon"), title2: "FindOffers".localizedString, icon2: UIImage(named: "findOffersIcon"), shouldShowSegment: true, isPayBillsView: isPayBillsView)
        }
        
        displayRewardPoints()
    }
    
    func displayLocationName(_ locationName: String) {
        topHeaderView.setLocation(locationName: locationName, locationNickName: "Home")
        
    }
    
    func displayRewardPoints() {
        if let rewardPoints = SmilesCategoriesUtli.shared.getValueFromUserDefaults(key: .rewardPoints) as? Int {
            self.topHeaderView.setPointsOfUser(with: rewardPoints.numberWithCommas())
        }
        
        if let rewardPointsIcon = SmilesCategoriesUtli.shared.getValueFromUserDefaults(key: .rewardPointsIcon) as? String {
            self.topHeaderView.setPointsIcon(with: rewardPointsIcon, shouldShowAnimation: false)
        }
    }
    
    private func updateView(index: Int) {
        if shouldAddBillsController {
            if index == 0 {
                self.input.send(.getSections(categoryID: categoryId, subCategoryId: subCategoryId))
            } else {
                self.delegate?.navigateToCategoryDetails(isFromViewAll: self.isFromViewAll,
                                                         personalizationEventSource: self.personalizationEventSource,
                                                         themeId: nil,
                                                         didScroll: { [weak self] scrollView in
                    self?.adjustTopHeader(scrollView)
                })
                
                self.delegate?.removeChild(viewController: self)
            }
        } else {
            self.delegate?.navigateToCategoryDetails(isFromViewAll: self.isFromViewAll,
                                                     personalizationEventSource: self.personalizationEventSource,
                                                     themeId: themeId,
                                                     didScroll: { [weak self] scrollView in
                self?.adjustTopHeader(scrollView)
            })
        }
    }
    
    func adjustTopHeader(_ scrollView: UIScrollView) {
        guard isHeaderExpanding == false else {return}
        if let tableView = scrollView as? UITableView {
            let items = (0..<tableView.numberOfSections).reduce(into: 0) { partialResult, sectionIndex in
                partialResult += tableView.numberOfRows(inSection: sectionIndex)
            }
            if items == 0 {
                return
            }
        }
        let isAlreadyCompact = !topHeaderView.bodyViewCompact.isHidden
        let compact = scrollView.contentOffset.y > 150
        if compact != isAlreadyCompact {
            isHeaderExpanding = true
            topHeaderView.adjustUI(compact: compact)
            topHeaderView.view_container.backgroundColor = compact ? .white : .appRevampFilterCountBGColor.withAlphaComponent(0.1)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.isHeaderExpanding = false
            }
        }
    }
    
    func setPersonalizationEventSource() {
        if let source = SharedConstants.personalizationEventSource {
            self.personalizationEventSource = source
            SharedConstants.personalizationEventSource = nil
        }
    }
}

// MARK: -- Configurations
extension CategoryContainerViewController {
    fileprivate func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        let topPlaceHolderResponse = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == SectionIdentifier.TOPPLACEHOLDER.rawValue })
        
        if let title = topPlaceHolderResponse?.title {
            headerTitle = title
            topHeaderView.setHeaderTitle(title: title)
        }
        
        if let iconURL = topPlaceHolderResponse?.iconUrl {
            topHeaderView.headerTitleImageView.isHidden = false
            topHeaderView.setHeaderTitleIcon(iconURL: iconURL)
        }
        
        if let searchTag = topPlaceHolderResponse?.searchTag {
            topHeaderView.setSearchText(with: searchTag)
        }
        if let delegate {
            delegate.navigateToBillPayRevamp(personalizationEventSource: self.personalizationEventSource)
        }
        if let childViewController = self.getChild(viewController: CategoryDetailsViewController.self) {
            self.removeChild(asChildViewController: childViewController)
        }
    }
}

extension CategoryContainerViewController: AppHeaderDelegate {
    public func didTapOnBackButton() {
        if isFromGifting {
            tabBarController?.selectedIndex = 0
            navigationController?.popToRootViewController()
        } else if isFromSummary {
            if let _ = presentingViewController {
                navigationController?.dismiss {
                    self.navigationController?.popToRootViewController(animated: false)
                }
            } else {
                navigationController?.popViewController()
            }
        } else {
            navigationController?.popViewController()
        }
    }
    
    public func didTapOnSearch() {
        if let delegate {
            delegate.navigateToGlobalSearchVC()
        }
    }
    
    public func didTapOnLocation() {
        if let delegate {
            delegate.navigateToUpdateLocationVC()
        }
    }
    
    func setLocationToolTipPositionView(view: UIImageView) {
//        self.locationToolTipPosition = view
    }
    
    public func segmentLeftBtnTapped(index: Int) {
        updateView(index: index)
        isPayBillsView = true
    }
    
    public func segmentRightBtnTapped(index: Int) {
        updateView(index: index)
        isPayBillsView = false
    }
    
    public func rewardPointsBtnTapped() {
        if let delegate {
            delegate.navigateToTransactionsListViewController(personalizationEventSource: self.personalizationEventSource)
        }
    }
}

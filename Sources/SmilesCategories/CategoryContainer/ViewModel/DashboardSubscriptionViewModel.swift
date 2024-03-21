//
//  DashboardSubscriptionViewModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 29/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesBanners
import SmilesUtilities

public class DashboardSubscriptionViewModel: NSObject {

    // MARK: - INPUT. View event methods
    public enum Input {
        case getSubscriptionBanner(menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?)
       // case getSubscriptionV2Banner(menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?)
    }
    
    public enum Output {
        case fetchSubscriptionBannersDidSucceed(response: GetTopOffersResponseModel)
        case fetchSubscriptionBannersDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private let topOffersViewModel = TopOffersViewModel()
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var topOffersUseCaseInput: PassthroughSubject<TopOffersViewModel.Input, Never> = .init()
}

// MARK: - INPUT. View event methods
public extension DashboardSubscriptionViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSubscriptionBanner(let menuItemType, let bannerType, let categoryId, let bannerSubType):
                self?.bind(to: self?.topOffersViewModel ?? TopOffersViewModel())
                self?.topOffersUseCaseInput.send(.getTopOffers(menuItemType: menuItemType, bannerType: bannerType, categoryId: categoryId, bannerSubType: bannerSubType, isGuestUser: AppCommonMethods.isGuestUser, baseUrl: AppCommonMethods.serviceBaseUrl))
//            case .getSubscriptionV2Banner(let menuItemType, let bannerType, let categoryId, let bannerSubType):
//                self?.getAllSubscriptionBanners(for: menuItemType, bannerType: bannerType, categoryId: categoryId, bannerSubType: nil,isBannerTwo: true)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // TopOffers ViewModel Binding
    func bind(to topOffersViewModel: TopOffersViewModel) {
        topOffersUseCaseInput = PassthroughSubject<TopOffersViewModel.Input, Never>()
        let output = topOffersViewModel.transform(input: topOffersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchTopOffersDidSucceed(let topOffersResponse):
                    self?.output.send(.fetchSubscriptionBannersDidSucceed(response: topOffersResponse))
                case .fetchTopOffersDidFail(let error):
                    self?.output.send(.fetchSubscriptionBannersDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
}

//
//  NearbyOffersViewModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 05/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer
import CoreLocation
import SmilesUtilities

public class NearbyOffersViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    public enum Input {
        case getNearbyOffers(pageNo: Int?)
    }
    
    public enum Output {
        case fetchNearbyOffersDidSucceed(response: NearbyOffersResponseModel)
        case fetchNearbyOffersDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

public extension NearbyOffersViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getNearbyOffers(let pageNo):
                self?.getNearbyOffers(with: pageNo)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getNearbyOffers(with pageNo: Int?) {
        
        let nearbyOffersRequest = NearbyOffersRequestModel(pageNo: pageNo, operationName: "/home/v1/deals-for-you", isGuestUser: AppCommonMethods.isGuestUser)
        
        let service = GetNearbyOffersRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            endPoint: .nearbyOffers
        )
        
        service.getNearbyOffersService(request: nearbyOffersRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchNearbyOffersDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchNearbyOffersDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}

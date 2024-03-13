//
//  NearbyOffersRepository.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 05/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer

protocol GetNearbyOffersServiceable {
    func getNearbyOffersService(request: NearbyOffersRequestModel) -> AnyPublisher<NearbyOffersResponseModel, NetworkError>
}

class GetNearbyOffersRepository: GetNearbyOffersServiceable {
    
    private var networkRequest: Requestable
    private var endPoint: DashboardRevampEndPoints

  // inject this for testability
    init(networkRequest: Requestable, endPoint: DashboardRevampEndPoints) {
        self.networkRequest = networkRequest
        self.endPoint = endPoint
    }
  
    func getNearbyOffersService(request: NearbyOffersRequestModel) -> AnyPublisher<NearbyOffersResponseModel, NetworkError> {
        let endPoint = NearbyOffersRequestBuilder.getNearbyOffers(request: request)
        let request = endPoint.createRequest(
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
}

//
//  CBDDetailsRepository.swift
//  House
//
//  Created by Shmeel Ahmad on 25/05/2023.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer

protocol CBDDetailsServiceable {
    func getCBDDetails(request: GetCBDDetailsRequest) -> AnyPublisher<CBDDetailsResponseModel, NetworkError>
}

class CBDDetailsRepository: CBDDetailsServiceable {
    func getCBDDetails(request: GetCBDDetailsRequest) -> AnyPublisher<CBDDetailsResponseModel, NetworkingLayer.NetworkError> {
        let endPoint = CBDDetailsRequestBuilder.getCBDDetails(request: request)
        let request = endPoint.createRequest(
            environment: self.environment,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
    
    
    private var networkRequest: Requestable
    private var environment: Environment?
    private var endPoint: CategoryDetailsEndPoints

  // inject this for testability
    init(networkRequest: Requestable, environment: Environment? = .UAT, endPoint: CategoryDetailsEndPoints) {
        self.networkRequest = networkRequest
        self.environment = environment
        self.endPoint = endPoint
    }
}

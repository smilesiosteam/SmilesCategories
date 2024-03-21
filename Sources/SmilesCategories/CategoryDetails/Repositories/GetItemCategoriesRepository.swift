//
//  GetItemCategoriesRepository.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

protocol GetItemCategoriesServiceable {
    func getItemCategoriesService(request: ItemCategoriesRequestModel) -> AnyPublisher<ItemCategoriesResponseModel, NetworkError>
}

public class GetItemCategoriesRepository: GetItemCategoriesServiceable {
    
    private var networkRequest: Requestable
//    private var environment: Environment?
    private var endPoint: DashboardRevampEndPoints

  // inject this for testability
    public init(networkRequest: Requestable, endPoint: DashboardRevampEndPoints) {
        self.networkRequest = networkRequest
        self.endPoint = endPoint
    }
  
    public func getItemCategoriesService(request: ItemCategoriesRequestModel) -> AnyPublisher<ItemCategoriesResponseModel, NetworkError> {
        let endPoint = ItemCategoriesRequestBuilder.getItemCategories(request: request)
        let request = endPoint.createRequest(
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
}

//
//  PopularRestaurantsRequestBuilder.swift
//  House
//
//  Created by Hanan Ahmed on 11/3/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import NetworkingLayer
import SmilesUtilities


// if you wish you can have multiple services like this in a project
enum PopularRestaurantsRequestBuilder {
    
    // organise all the end points here for clarity
    case getPopularRestaurants(request: GetPopularRestaurantsRequestModel)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getPopularRestaurants:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(endPoint: FoodOrderHomeEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getPopularRestaurants(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(for endPoint: FoodOrderHomeEndPoints) -> String {
        let baseUrl = AppCommonMethods.serviceBaseUrl
        let endPoint = endPoint.serviceEndPoints
        
        switch self {
        case .getPopularRestaurants:
            return "\(baseUrl)\(endPoint)"
        }
    }
}

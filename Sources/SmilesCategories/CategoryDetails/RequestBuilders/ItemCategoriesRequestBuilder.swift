//
//  ItemCategoriesRequestBuilder.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

// if you wish you can have multiple services like this in a project
enum ItemCategoriesRequestBuilder {
    
    // organise all the end points here for clarity
    case getItemCategories(request: ItemCategoriesRequestModel)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getItemCategories:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(endPoint: DashboardRevampEndPoints) -> NetworkRequest {
        var headers: [String:String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getItemCategories(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(for endPoint: DashboardRevampEndPoints) -> String {
        let baseUrl = AppCommonMethods.serviceBaseUrl
        let endPoint = endPoint.serviceEndPoints
        
        switch self {
        case .getItemCategories:
            return "\(baseUrl)\(endPoint)"
        }
    }
}

//
//  CBDDetailsRequestBuilder.swift
//  House
//
//  Created by Shmeel Ahmad on 025/05/2023.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

// if you wish you can have multiple services like this in a project
enum CBDDetailsRequestBuilder {
    
    // organise all the end points here for clarity
    case getCBDDetails(request: GetCBDDetailsRequest)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getCBDDetails:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(endPoint: CategoryDetailsEndPoints) -> NetworkRequest {
        var headers: Headers = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getCBDDetails(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(for endPoint: CategoryDetailsEndPoints) -> String {
        let baseUrl = AppCommonMethods.serviceBaseUrl //environment?.serviceBaseUrl
        let endPoint = endPoint.serviceEndPoints
        
        switch self {
        case .getCBDDetails:
            return "\(baseUrl ?? "")\(endPoint)"
        }
    }
}

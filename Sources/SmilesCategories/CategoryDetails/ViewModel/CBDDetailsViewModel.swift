//
//  CBDDetailsViewModel.swift
//  House
//
//  Created by Shmeel Ahmad on 25/05/2023.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer
import CoreLocation

class CBDDetailsViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case getCBDDetails
    }
    
    enum Output {
        case fetchCBDDetailsDidSucceed(response: CBDDetailsResponseModel)
        case fetchCBDDetailsDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension CBDDetailsViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getCBDDetails:
                self?.getCBDDetails()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getCBDDetails() {
        
        let request = GetCBDDetailsRequest()
        
        let service = CBDDetailsRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            endPoint: .CBDDetails
        )
        
        service.getCBDDetails(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchCBDDetailsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response.jsonString() ?? "N/A")")
                self?.output.send(.fetchCBDDetailsDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}

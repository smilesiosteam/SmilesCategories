//
//  ItemCategoriesViewModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

class ItemCategoriesViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case getItemCategories
    }
    
    enum Output {
        case fetchItemCategoriesDidSucceed(response: ItemCategoriesResponseModel)
        case fetchItemCategoriesDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension ItemCategoriesViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getItemCategories:
                self?.getItemCategories()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getItemCategories() {
        let itemCategoriesRequest = ItemCategoriesRequestModel(isGuestUser: AppCommonMethods.isGuestUser)
        
        let service = GetItemCategoriesRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            endPoint: .itemCategories
        )
        
        service.getItemCategoriesService(request: itemCategoriesRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchItemCategoriesDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchItemCategoriesDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}

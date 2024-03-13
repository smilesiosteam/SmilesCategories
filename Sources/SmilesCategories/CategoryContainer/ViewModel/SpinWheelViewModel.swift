//
//  SpinWheelViewModel.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 07/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import Combine
import NetworkingLayer
import CoreLocation

class SpinWheelViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case optInToSpinWheel
        case getLotterySeries(displayType: gameDisplayTypes?)
    }
    
    enum Output {
        case optInToSpinWheelDidSucceed(optIn: Bool)
        case optInToSpinWheelDidFail(error: Error)
        
        case getLotterySeriesDidSucceed(response: LotterySeriesResponseModel)
        case getLotterySeriesDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension SpinWheelViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .optInToSpinWheel:
                self?.optInToSpinWheel()
            case .getLotterySeries(let displayType):
                self?.getLotterySeries(displayType: displayType)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func optInToSpinWheel() {
//        UserDefaults.standard.set(false, forKey: .isOtpIn)
        
        let optInFlag = UserDefaults.standard.bool(forKey: .isOtpIn)
        
        if !optInFlag {
            let spinWheelOptInRequest = SpinWheelOptInRequestModel()
            
            let service = GetSpinWheelRepository(
                networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
                endPoint: .spinWheelOptIn
            )
            
            service.optInToSpinWheelService(request: spinWheelOptInRequest)
                .sink { [weak self] completion in
                    debugPrint(completion)
                    switch completion {
                    case .failure(let error):
                        self?.output.send(.optInToSpinWheelDidFail(error: error))
                        self?.output.send(.optInToSpinWheelDidSucceed(optIn: false))
                    case .finished:
                        debugPrint("nothing much to do here")
                    }
                } receiveValue: { [weak self] response in
                    debugPrint("got my response here \(response)")
                    if response.status == 200 {
                        self?.output.send(.optInToSpinWheelDidSucceed(optIn: true))
                        UserDefaults.standard.set(true, forKey: .isOtpIn)
                    } else {
                        self?.output.send(.optInToSpinWheelDidSucceed(optIn: false))
                    }
                }
            .store(in: &cancellables)
        } else {
            self.output.send(.optInToSpinWheelDidSucceed(optIn: true))
        }
    }
    
    func getLotterySeries(displayType: gameDisplayTypes?) {
        var gameTypeObj: String?
        
        if let appInfo = getUserProfileResponse.sharedClient(), let resources = appInfo.onAppStartObjectResponse, let gameType = resources.gamificationHomeSectionGame {
            gameTypeObj = gameType
        }
        
        let lotterySeriesRequest = LotterySeriesRevampRequestModel(gameType: gameTypeObj, action: displayType?.rawValue)
        
        let service = GetSpinWheelRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            endPoint: .getLotterySeries
        )
        
        service.getLotterySeriesService(request: lotterySeriesRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.getLotterySeriesDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.getLotterySeriesDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}

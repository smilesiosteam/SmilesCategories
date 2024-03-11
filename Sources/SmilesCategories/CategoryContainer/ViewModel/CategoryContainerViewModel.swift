//
//  CategoryContainerViewModel.swift
//  House
//
//  Created by Shahroze Zaheer on 21/12/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesUtilities

class CategoryContainerViewModel {
    
    // MARK: -- Variables
    
    private let sectionsViewModel = SectionsViewModel()
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
}

// MARK: - INPUT. View event methods
extension CategoryContainerViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .getSections(let categoryID, let subcategoryId):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, subCategoryId: subcategoryId, baseUrl: Environment.UAT.serviceBaseUrl, isGuestUser: isGuestUser))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // MARK: -- Binding
    
    // Sections ViewModel Binding
    func bind(to sectionsViewModel: SectionsViewModel) {
        sectionsUseCaseInput = PassthroughSubject<SectionsViewModel.Input, Never>()
        let output = sectionsViewModel.transform(input: sectionsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    print(sectionsResponse)
                    self?.output.send(.fetchSectionsDidSucceed(response: sectionsResponse))
                case .fetchSectionsDidFail(let error):
                    self?.output.send(.fetchSectionsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
}

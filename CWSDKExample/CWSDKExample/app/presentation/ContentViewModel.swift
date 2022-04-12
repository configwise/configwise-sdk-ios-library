//
//  ContentViewModel.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import Resolver

class ContentViewModel: ObservableObject {

    @Published var isLoading = true

    @Published var isAuthorised = false

    @LazyInjected private var isAuthorisedUseCase: IsAuthorisedUseCase

    private var subscriptions = Set<AnyCancellable>()

    func verifyIfAuthorised() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }

        self.isAuthorisedUseCase.execute()
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] in
                    self?.isAuthorised = $0
                }
            )
            .store(in: &self.subscriptions)
    }
}

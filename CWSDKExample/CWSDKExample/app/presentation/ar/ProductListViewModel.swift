//
//  ProductListViewModel.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import Resolver
import CWSDKData

class ProductListViewModel: ObservableObject {

    @Published var errorMessage: String?

    @Published var isLoading = false

    @Published var loadingTitle = "Loading"

    @Published var catalogItems = [CWCatalogItemEntity]()

    @LazyInjected private var getCatalogItemsUseCase: GetCatalogItemsUseCase

    private var subscriptions = Set<AnyCancellable>()

    func getCatalogItems() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorMessage = nil
            self.isLoading = true
        }

        let query = CWCatalogItemQuery()

        self.getCatalogItemsUseCase.execute(query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }

                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                },
                receiveValue: { [weak self] in
                    guard let self = self else { return }
                    self.catalogItems = $0
                }
            )
            .store(in: &self.subscriptions)
    }
}

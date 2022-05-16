//
//  GetCatalogItemUseCase.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import CWSDKData

public class GetCatalogItemUseCase {

    private let catalogItemRepository: CWCatalogItemRepository

    public init(catalogItemRepository: CWCatalogItemRepository) {
        self.catalogItemRepository = catalogItemRepository
    }

    public func execute(_ query: CWCatalogItemQuery) -> AnyPublisher<CWCatalogItemEntity?, Error> {
        return catalogItemRepository.getCatalogItemAsync(query)
    }
}

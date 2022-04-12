//
//  CreateArObjectUseCase.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import CWSDKData
import CWSDKRender

public class CreateArObjectUseCase {

    private let arObjectRepository: CWArObjectRepository

    public init(arObjectRepository: CWArObjectRepository) {
        self.arObjectRepository = arObjectRepository
    }

    public func execute(_ entity: CWCatalogItemEntity) -> CWArObjectEntity {
        return self.arObjectRepository.createArObject(catalogItem: entity)
    }
}

//
//  DomainDI.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Resolver

extension Resolver {
    static func registerDomain() {
        register { IsAuthorisedUseCase(authRepository: resolve()) }
        register { LoginUseCase(authRepository: resolve()) }
        register { LogoutUseCase(authRepository: resolve()) }
        register { GetCatalogItemsUseCase(catalogItemRepository: resolve()) }
        register { GetCatalogItemUseCase(catalogItemRepository: resolve()) }
        register { CreateArObjectUseCase(arObjectRepository: resolve()) }
    }
}

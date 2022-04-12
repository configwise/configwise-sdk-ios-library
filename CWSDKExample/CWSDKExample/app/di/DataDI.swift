//
//  DataDI.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Resolver
import CWSDKData
import CWSDKRender

extension Resolver {

    static func registerDataImpl() {
        register { CWAuthRepositoryImpl() }
            .implements(CWAuthRepository.self)
            .scope(.application)

        register { CWCatalogItemRepositoryImpl() }
            .implements(CWCatalogItemRepository.self)
            .scope(.application)

        register { CWDownloadingRepositoryImpl() }
            .implements(CWDownloadingRepository.self)
            .scope(.application)

        register { CWArObjectRepositoryImpl(downloadingRepository: resolve()) }
            .implements(CWArObjectRepository.self)
            .scope(.application)
    }
}

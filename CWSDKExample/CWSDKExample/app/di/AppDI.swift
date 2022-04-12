//
//  AppDI.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        // DI Scopes:
        // Graph: Graph is Resolver’s default scope.
        //        Once Resolver resolves the requested object, it discards all objects created in that flow.
        //        Consequently, the next call to Resolver creates new instances.
        //
        // Application: Application scope is the same as a singleton.
        //              The first time Resolver resolves an object, it retains the instance and uses
        //              it for all subsequent resolutions as long as the app is alive.
        //              You can define that by adding .scope(.application) to your registrations.
        defaultScope = .graph

        registerDataImpl()

        registerDomain()
    }
}

//
//  AppEnvironment.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import CWSDKData

final class AppEnvironment: ObservableObject {

    static private(set) var _buildConfig: BuildConfig?
    static var buildConfig: BuildConfig {
        if _buildConfig == nil {
            guard let infoDictionary = Bundle.main.infoDictionary else {
                fatalError("Unable to initialize due no Info.plist")
            }

            _buildConfig = BuildConfig(infoDictionary)
        }

        return _buildConfig!
    }

    @Published var isAuthorised = false

    private var subscriptions = Set<AnyCancellable>()

    init() {
        ConfigWiseSDK.initialize([
            .channelToken("PUT_YOUR_CHANNEL_TOKEN_HERE"),
            .authMode(.b2c)
            // ,.testMode(true) // Set testMode as true to use TEST ConfigWise service, otherwise PROD environment used.
        ])

        NotificationCenter.default.publisher(for: ConfigWiseSDK.unauthorizedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isAuthorised = false
            }
            .store(in: &self.subscriptions)
    }

}

// MARK: - BuildConfig

struct BuildConfig {

    let versionName: String

    let versionBuildNumber: String

    init(_ infoDictionary: [String : Any]) {
        self.versionName = infoDictionary["CFBundleShortVersionString"] as! String
        self.versionBuildNumber = infoDictionary["CFBundleVersion"] as! String

        #if DEBUG
        print("CWSDKExample BuildConfig: \(self)")
        #endif
    }
}

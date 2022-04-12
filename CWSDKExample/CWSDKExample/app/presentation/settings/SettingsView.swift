//
//  SettingsView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Text("Settings - under construction.")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let appEnvironment = AppEnvironment()

        return SettingsView(SettingsViewModel())
            .environmentObject(appEnvironment)
    }
}
#endif

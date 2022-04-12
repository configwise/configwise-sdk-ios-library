//
//  ContentView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI
import Combine

struct ContentView : View {

    @EnvironmentObject var appEnvironment: AppEnvironment

    @StateObject private var viewModel: ContentViewModel

    init(_ viewModel: ContentViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                SplashView()
            } else {
                if appEnvironment.isAuthorised {
                    HomeView(HomeViewModel())
                } else {
                    LoginView(LoginViewModel())
                }
            }
        }
        .onAppear {
            // Let's init @Binding between ViewModels
            viewModel.$isAuthorised.assign(to: &appEnvironment.$isAuthorised)

            viewModel.verifyIfAuthorised()
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let appEnvironment = AppEnvironment()

        return ContentView(ContentViewModel())
            .environmentObject(appEnvironment)
    }
}
#endif

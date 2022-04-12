//
//  HomeView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI
import CWSDKData

struct HomeView: View {

    @EnvironmentObject var appEnvironment: AppEnvironment

    @StateObject private var viewModel: HomeViewModel

    @State private var navigateTo: String?

    @State private var showError: Bool = false

    init(_ viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        LoadingView(title: $viewModel.loadingTitle, isShowing: $viewModel.isLoading) {
            NavigationView {
                VStack {
                    NavigationLink(
                        destination: SettingsView(SettingsViewModel()),
                        tag: "TAG_NAVIGATE_TO_SETTINGS",
                        selection: $navigateTo
                    ) { EmptyView() }

                    List(viewModel.catalogItems) { entity in
                        NavigationLink(destination: ARSceneView(ARSceneViewModel(initialCatalogItemId: entity.id))) {
                            HStack {
                                // See details and notes how to use AsyncImage, here:
                                // https://stackoverflow.com/a/67919836
                                AsyncImage(url: entity.thumbnailUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)

                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .transition(.opacity.combined(with: .scale))

                                    case.failure(_):
                                        Image(systemName: "xmark.octagon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)

                                    @unknown default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                                .frame(width: 60, height: 60)

                                Text(entity.name)
                                    .font(.headline)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    .onAppear {
                        viewModel.getCatalogItems()
                    }
                    .refreshable {
                        // TODO [smuravev] BUG: Currently async / await '.refreshable' not compatible with
                        //                 our ViewModel / Combine approach - there are UX artifacts at this moment.
                        //                 Make it compatible further, see tutorial, here:
                        //                 https://blckbirds.com/post/mastering-pull-to-refresh-in-swiftui/
                        viewModel.getCatalogItems()
                    }
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(
                    trailing: HStack {
                        Spacer()
                        Button(action: {
                            navigateTo = "TAG_NAVIGATE_TO_SETTINGS"
                        }) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        if ConfigWiseSDK.authMode == .b2b {
                            Button(action: {
                                viewModel.logout()
                            }) {
                                Image(systemName: "power")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear {
            viewModel.$logoutDone.map { !$0 }.assign(to: &appEnvironment.$isAuthorised)
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("ERROR".uppercased()),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .onReceive(viewModel.$errorMessage) { errorMessage in
            showError = errorMessage != nil
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let appEnvironment = AppEnvironment()

        return HomeView(HomeViewModel())
            .environmentObject(appEnvironment)
    }
}
#endif

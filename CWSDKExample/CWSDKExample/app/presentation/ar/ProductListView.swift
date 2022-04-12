//
//  ProductListView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI
import CWSDKData


struct ProductListView: View {

    private let didSelect: (CWCatalogItemEntity) -> Void

    @StateObject private var viewModel = ProductListViewModel()

    init(didSelect: @escaping (CWCatalogItemEntity) -> Void) {
        self.didSelect = didSelect
    }

    var body: some View {
        LoadingView(title: $viewModel.loadingTitle, isShowing: $viewModel.isLoading) {
            List(viewModel.catalogItems) { entity in
                Button(action: {
                    self.didSelect(entity)
                }) {
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
        }
        .onAppear {
            viewModel.getCatalogItems()
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil }}
        )) {
            Alert(
                title: Text("ERROR".uppercased()),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#if DEBUG
struct ProductListView_Previews: PreviewProvider {

    static var previews: some View {
        let appEnvironment = AppEnvironment()

        return ProductListView { catalogItem in
            print("Product '\(catalogItem.name)' has been selected.")
        }
        .environmentObject(appEnvironment)
    }
}
#endif

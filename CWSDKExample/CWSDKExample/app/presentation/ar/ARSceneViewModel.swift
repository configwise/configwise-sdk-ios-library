//
//  ARSceneViewModel.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import Resolver
import ARKit
import RealityKit
import CWSDKData
import CWSDKRender

enum ARSceneErrorMessage {
    case error(String)
    case critical(String)

    var message: String {
        switch self {
        case .error(let message):
            return message
        case .critical(let message):
            return message
        }
    }
}

enum ARSceneFlowState {
    case notInitialized
    case initializing
    case initialized
    case placement(CWArObjectEntity)
}

class ARSceneViewModel: NSObject, ObservableObject {

    @Published var errorMessage: ARSceneErrorMessage?

    @Published var isLoading = false

    @Published var loadingTitle = "Loading"

    @Published var arAdapter: CWArAdapter? {
        willSet {
            guard self.arAdapter != newValue else { return }
            self.arAdapter?.pauseArSession()
        }
        didSet {
            guard let arAdapter = self.arAdapter else { return }

            arAdapter.delegateQueue = self.arDelegateQueue
            arAdapter.arSessionDelegate = self
            arAdapter.arCoachingOverlayViewDelegate = self
            arAdapter.arObjectSelectionDelegate = self
            arAdapter.arObjectManagementDelegate = self

            arAdapter.coachingEnabled = true
            arAdapter.hudColor = .blue
            arAdapter.hudEnabled = true
            arAdapter.arObjectSelectionMode = .single
        }
    }

    @Published var selectedArObject: CWArObjectEntity?

    @Published var flowState: ARSceneFlowState = .notInitialized

    @Published var urlRequestToOpen: URLRequest?

    @Published var openProductList = false

    @LazyInjected private var getCatalogItemUseCase: GetCatalogItemUseCase

    @LazyInjected private var createArObjectUseCase: CreateArObjectUseCase

    private let initialCatalogItemId: Int?

    private let arDelegateQueue = DispatchQueue(label: "QueueArDelegate_\(UUID().uuidString)")

    private var subscriptions = Set<AnyCancellable>()

    init(initialCatalogItemId: Int? = nil) {
        self.initialCatalogItemId = initialCatalogItemId
    }
}

// MARK: - Business logic

extension ARSceneViewModel {

    func runArSession() {
        arAdapter?.runArSession()

        guard case .notInitialized = flowState else { return }

        // Let's load initial CatalogItem if exist

        // If flow state not initalized yet then we fetch initial CatalogItem
        DispatchQueue.main.async { [weak self] in
            self?.flowState = .initializing
        }

        guard let initialCatalogItemId = self.initialCatalogItemId else {
            DispatchQueue.main.async { [weak self] in
                self?.flowState = .initialized
            }
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorMessage = nil
            self.isLoading = true
        }

        self.getCatalogItemUseCase.execute(CWCatalogItemQuery(id: initialCatalogItemId))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }

                    if case .failure(let error) = completion {
                        self.errorMessage = .error(error.localizedDescription)
                        self.flowState = .initialized
                    }
                    self.isLoading = false
                },
                receiveValue: { [weak self] in
                    guard let catalogItem = $0 else { return }
                    self?.startPlacement(catalogItem: catalogItem)
                }
            )
            .store(in: &self.subscriptions)
    }

    func pauseArSession() {
        arAdapter?.pauseArSession()
    }

    func startPlacement(catalogItem: CWCatalogItemEntity) {
        let arObject = self.createArObjectUseCase.execute(catalogItem)
        startPlacement(arObject: arObject)
    }

    func startPlacement(arObject: CWArObjectEntity) {
        self.flowState = .placement(arObject)

        if let arAdapter = self.arAdapter {
            arAdapter.hudShown = true
            arAdapter.hudObject = arObject
        }
        if case .notRequested = arObject.loadableContent {
            arObject.load()
        }
    }

    func finishPlacement() {
        if let arAdapter = self.arAdapter {
            if let arObject = arAdapter.placeArObjectFromHud() {
                arAdapter.selectArObject(arObject)
            }
            arAdapter.hudShown = false
        }

        self.flowState = .initialized
    }

    func removeSelectedObject() {
        guard let arObject = self.selectedArObject else { return }
        self.arAdapter?.removeArObject(arObject)
    }

    func openProductUrl() {
        guard let url = self.selectedArObject?.catalogItem.productUrl else { return }
        DispatchQueue.main.async { [weak self] in
            self?.urlRequestToOpen = URLRequest(url: url)
        }
    }

    func openProductListDialog() {
        DispatchQueue.main.async { [weak self] in
            self?.openProductList = true
        }
    }

    func closeProductListDialog() {
        DispatchQueue.main.async { [weak self] in
            self?.openProductList = false
        }
    }
}

// MARK: - CWArObjectSelectionDelegate

extension ARSceneViewModel: CWArObjectSelectionDelegate {

    func arObjectSelected(_ arObject: CWArObjectEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedArObject = arObject
        }

        if let error = arObject.loadableContent.error {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = .error("Unable to load product model due: \(error.localizedDescription)")
            }
        }
    }

    func arObjectDeselected(_ arObject: CWArObjectEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedArObject = nil
        }
    }
}

// MARK: - CWArObjectManagementDelegate

extension ARSceneViewModel: CWArObjectManagementDelegate {

    func arObjectAdded(_ arObject: CWArObjectEntity) {
    }

    func arObjectRemoved(_ arObject: CWArObjectEntity) {
        if arObject == self.selectedArObject {
            DispatchQueue.main.async { [weak self] in
                self?.selectedArObject = nil
            }
        }
    }
}

// MARK: - ARSessionDelegate, ARSessionObserver

extension ARSceneViewModel: ARSessionDelegate {

    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = .critical(error.localizedDescription)
        }
    }
}

// MARK: - ARCoachingOverlayViewDelegate

extension ARSceneViewModel: ARCoachingOverlayViewDelegate {
}

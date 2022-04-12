//
//  ARViewWrapper.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI
import RealityKit
import CWSDKRender

struct ARViewWrapper: UIViewRepresentable {

    @Binding var arAdapter: CWArAdapter?

    func makeCoordinator() -> ARViewWrapper.Coordinator {
        return Coordinator(representable: self, frame: .zero)
    }

    func makeUIView(context: Context) -> ARView {
        let coordinator = context.coordinator
        let arAdapter = coordinator.arAdapter
        self.arAdapter = arAdapter

        return arAdapter.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        coordinator.representable.arAdapter = nil
    }

    // MARK: - Coordinator

    final class Coordinator {

        let representable: ARViewWrapper

        let arAdapter: CWArAdapter

        init(representable: ARViewWrapper, frame: CGRect) {
            self.representable = representable
            self.arAdapter = CWArAdapter(frame: frame)
        }
    }
}

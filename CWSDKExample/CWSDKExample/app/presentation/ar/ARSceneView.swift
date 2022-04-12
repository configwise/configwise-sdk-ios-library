//
//  ARSceneView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI
import CWSDKRender

struct ARSceneView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject private var viewModel: ARSceneViewModel

    init(_ viewModel: ARSceneViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack{
            ARViewWrapper(arAdapter: $viewModel.arAdapter)
            .onAppear {
                viewModel.runArSession()
            }

            VStack {
                if let catalogItem = viewModel.selectedArObject?.catalogItem {
                    VStack {
                        Text(catalogItem.name)
                            .lineLimit(1)
                            .padding(10)

                        if let ean = catalogItem.ean {
                            Text(ean)
                                .lineLimit(1)
                                .font(.footnote)
                                .padding(10)
                        }
                    }
                    .modifier(MyStyleArModal(backgroundColor: Color(uiColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), cornerRadius: 5))
                    .padding(EdgeInsets(top: 80, leading: 40, bottom: 40, trailing: 40))
                }

                Spacer()

                HStack {
                    ArButtonAction(
                        enabled: viewModel.selectedArObject?.catalogItem.productUrl != nil,
                        width: 40,
                        height: 40,
                        cornerRadius: 20,
                        image: Image(systemName: "arrow.turn.down.right"),
                        onAction: {
                            viewModel.openProductUrl()
                        }
                    )

                    switch viewModel.flowState {
                    case .notInitialized:
                        Spacer()
                    case .initializing:
                        Spacer()
                    case .placement(_):
                        Spacer()
                        ArButtonAction(
                            enabled: true,
                            image: Image(systemName: "checkmark"),
                            onAction: {
                                viewModel.finishPlacement()
                            }
                        )
                        Spacer()
                    case .initialized:
                        if let selectedArObject = viewModel.selectedArObject {
                            Spacer()
                            ArButtonAction(
                                enabled: true,
                                image: Image(systemName: "viewfinder"),
                                onAction: {
                                    viewModel.startPlacement(arObject: selectedArObject)
                                }
                            )
                            Spacer()
                        } else {
                            Spacer()
                            ArButtonAction(
                                enabled: true,
                                image: Image(systemName: "plus"),
                                onAction: {
                                    viewModel.openProductListDialog()
                                }
                            )
                            Spacer()
                        }
                    }

                    ArButtonAction(
                        enabled: viewModel.selectedArObject != nil,
                        width: 40,
                        height: 40,
                        cornerRadius: 20,
                        image: Image(systemName: "trash"),
                        onAction: {
                            viewModel.removeSelectedObject()
                        }
                    )
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil }}
            )) {
                if case .critical = viewModel.errorMessage {
                    return Alert(
                        title: Text("CRITICAL ERROR".uppercased()),
                        message: Text(viewModel.errorMessage?.message ?? ""),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                } else {
                    return Alert(
                        title: Text("ERROR".uppercased()),
                        message: Text(viewModel.errorMessage?.message ?? ""),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("AR camera")
        .navigationBarItems(
            trailing: HStack {
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
//                        .tint(.blue)
                }
            }
        )
        .sheet(isPresented: Binding<Bool>(
            get: {
                viewModel.urlRequestToOpen != nil || viewModel.openProductList
            },
            set: {
                if !$0 {
                    viewModel.urlRequestToOpen = nil
                    viewModel.openProductList = false
                }
            }
        )) {
            if viewModel.openProductList {
                ProductListView() { catalogItem in
                    viewModel.closeProductListDialog()
                    viewModel.startPlacement(catalogItem: catalogItem)
                }
            } else if let urlRequest = viewModel.urlRequestToOpen {
                WebView(urlRequest: urlRequest)
            }
        }
    }
}

// MARK: - UI, Styling

private struct ArButtonAction: View {

    var enabled: Bool

    var width: CGFloat = 60

    var height: CGFloat = 60

    var cornerRadius: CGFloat = 30

    var image: Image

    var onAction: (() -> ())?

    var body: some View {
        Button(action: {
            onAction?()
        }) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 10)
                .foregroundColor(enabled ? Color(uiColor: #colorLiteral(red: 0.2705882353, green: 0.3098039216, blue: 0.3882352941, alpha: 1)) : Color(uiColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)))
                .frame(width: width, height: height)
        }
        .modifier(MyStyleArButton(
            enabled: enabled,
            cornerRadius: cornerRadius,
            enabledColor: Color(uiColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
            disabledColor: Color(uiColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        ))
        .padding()
        .disabled(!enabled)
    }
}

private struct MyStyleArButton: ViewModifier {

    private var enabled: Bool

    private var transparent: Bool

    private var cornerRadius: CGFloat

    private var lineWidth: CGFloat

    private var enabledColor: Color

    private var disabledColor: Color

    private let opacity = 0.6

    init(
        enabled: Bool = true,
        transparent: Bool = true,
        cornerRadius: CGFloat = 5,
        lineWidth: CGFloat = 1,
        enabledColor: Color = Color(uiColor: #colorLiteral(red: 0.2705882353, green: 0.3098039216, blue: 0.3882352941, alpha: 1)),
        disabledColor: Color = Color(uiColor: #colorLiteral(red: 0.5991814733, green: 0.5991814733, blue: 0.5991814733, alpha: 1))
    ) {
        self.enabled = enabled
        self.transparent = transparent
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }

    func body(content: Content) -> some View {
        return content
            .background(
                self.enabled
                    ? self.transparent ? enabledColor.opacity(opacity) : enabledColor
                    : self.transparent ? disabledColor.opacity(opacity) : disabledColor
            )
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .stroke(
                        self.enabled
                            ? self.transparent ? enabledColor.opacity(opacity) : enabledColor
                            : self.transparent ? disabledColor.opacity(opacity) : disabledColor,

                        lineWidth: self.lineWidth
                    )
            )
            .shadow(radius: self.cornerRadius)
    }
}

private struct MyStyleArModal: ViewModifier {

    private var transparent: Bool

    private var backgroundColor: Color

    private var cornerRadius: CGFloat = 10

    private var lineWidth: CGFloat = 1

    private let opacity = 0.6

    init(
        transparent: Bool = true,
        backgroundColor: Color,
        cornerRadius: CGFloat = 10,
        lineWidth: CGFloat = 1
    ) {
        self.transparent = transparent
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
    }

    func body(content: Content) -> some View {
        return content
            .background(backgroundColor.opacity(opacity))
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(backgroundColor.opacity(opacity), lineWidth: lineWidth)
            )
            .shadow(color: Color(uiColor: #colorLiteral(red: 0.1647058824, green: 0.1803921569, blue: 0.262745098, alpha: 0.05129863411)), radius: cornerRadius)
    }
}

#if DEBUG
struct ARSceneView_Previews: PreviewProvider {
    static var previews: some View {
        let appEnvironment = AppEnvironment()

        return ARSceneView(ARSceneViewModel())
            .environmentObject(appEnvironment)
    }
}
#endif

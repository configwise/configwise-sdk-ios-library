//
//  WebView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let urlRequest: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(self.urlRequest)
    }
}

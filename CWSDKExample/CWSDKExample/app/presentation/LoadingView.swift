//
//  LoadingView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var title: String

    @Binding var isShowing: Bool

    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text(title)
                        .font(.subheadline)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(8)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(title: .constant("Loading"), isShowing: .constant(true)) {
            Text("Here is the content")
        }
    }
}
#endif

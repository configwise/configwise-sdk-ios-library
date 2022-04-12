//
//  SplashView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI

struct SplashView: View {

    var body: some View {
        VStack {
            Spacer()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())

            Spacer()

            HStack {
                Spacer()
                Text("v\(AppEnvironment.buildConfig.versionName)")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        let appEnvironment = AppEnvironment()
        return SplashView()
            .environmentObject(appEnvironment)
    }
}
#endif

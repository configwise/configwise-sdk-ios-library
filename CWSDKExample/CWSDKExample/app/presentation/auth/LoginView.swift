//
//  LoginView.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import SwiftUI
import CWSDKData

struct LoginView: View {

    @EnvironmentObject var appEnvironment: AppEnvironment

    @StateObject private var viewModel: LoginViewModel

    init(_ viewModel: LoginViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        LoadingView(title: .constant("Authorization"), isShowing: $viewModel.isLoading) {
            NavigationView {
                VStack {
                    ScrollView {
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding()

                            if ConfigWiseSDK.authMode == .b2c {
                                Button(action: {
                                    viewModel.login()
                                }) {
                                    Text("Try again")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width - 120)
                                        .padding()
                                }
                                .background(Color.accentColor)
                                .cornerRadius(8.0)
                                .padding()
                            }
                        }

                        if ConfigWiseSDK.authMode == .b2b {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Email")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.init(.label))
                                        .frame(width: 80, alignment: .leading)

                                    TextField("john.doe@email.me", text: $viewModel.email)
                                }
                                Divider()

                                if let errorMessage = viewModel.emailErrorMessage {
                                    Text(errorMessage)
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundColor(.red)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.top)

                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Password")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.init(.label))
                                        .frame(width: 80, alignment: .leading)

                                    SecureField("Type your password, here", text: $viewModel.password)
                                }
                                Divider()

                                if let errorMessage = viewModel.passwordErrorMessage {
                                    Text(errorMessage)
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundColor(.red)
                                        .lineLimit(1)
                                }
                            }

                            Button(action: {
                                viewModel.login()
                            }) {
                                Text("Login")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width - 120)
                                    .padding()
                            }
                            .background(Color.accentColor)
                            .cornerRadius(8.0)
                            .padding()

                           // TODO [smuravev] B2B: Implement 'Forgot Password' capability in the Login screen.
//                           NavigationLink(destination: ForgotPasswordView(ForgotPasswordViewModel())) {
//                               Text("Forgot password?")
//                                   .font(.headline)
//                                   .fontWeight(.regular)
//                           }
//                           .padding()
                        }
                    }

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
                .navigationBarTitle(Text("Login"), displayMode: .inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear {
            // Let's init @Binding between ViewModels
            viewModel.$success.assign(to: &appEnvironment.$isAuthorised)

            if ConfigWiseSDK.authMode == .b2c {
                viewModel.login()
            }
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let appEnvironment = AppEnvironment()

        return LoginView(LoginViewModel())
            .environmentObject(appEnvironment)
    }
}
#endif

//
//  LoginViewModel.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import Resolver
import CWSDKData

class LoginViewModel: ObservableObject {

    @Published var errorMessage: String?

    @Published var isLoading = false

    @Published var success = false

    @Published var email = ""

    @Published var emailErrorMessage: String?

    private var emailFirstAttempt = false

    @Published var password = ""

    @Published var passwordErrorMessage: String?

    private var passwordFirstAttempt = false

    @LazyInjected private var loginUseCase: LoginUseCase

    private var subscriptions = Set<AnyCancellable>()

    init() {
        self.$email
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                guard self.emailFirstAttempt else {
                    self.emailFirstAttempt = true
                    return
                }
                self.emailErrorMessage = value.isEmpty ? "Email must not be blank." : nil
            }
            .store(in: &subscriptions)

        self.$password
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                guard self.passwordFirstAttempt else {
                    self.passwordFirstAttempt = true
                    return
                }
                self.passwordErrorMessage = value.isEmpty ? "Password must not be blank." : nil
            }
            .store(in: &subscriptions)
    }

    func login() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.emailErrorMessage = nil
            self.passwordErrorMessage = nil
            self.isLoading = true
        }

        var query = CWLoginQuery()
        if ConfigWiseSDK.authMode == .b2b {
            query.username = self.email
            query.password = self.password
        }

        self.loginUseCase.execute(query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }

                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                },
                receiveValue: { [weak self] in
                    guard let self = self else { return }
                    self.success = $0.success
                    self.errorMessage = !$0.success
                        ? $0.message ?? "Authorization failed due not success."
                        : nil
                }
            )
            .store(in: &self.subscriptions)
    }
}

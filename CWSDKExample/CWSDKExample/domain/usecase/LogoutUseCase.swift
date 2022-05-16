//
//  LogoutUseCase.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import CWSDKData

public class LogoutUseCase {

    private let authRepository: CWAuthRepository

    public init(authRepository: CWAuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> AnyPublisher<Void, Never> {
        return authRepository.logoutAsync()
            .catch { error -> Just<Void> in
                print("ERROR [LogoutUseCase.execute]", error)
                return Just(())
            }
            .eraseToAnyPublisher()
    }
}

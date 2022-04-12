//
//  LoginUseCase.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import CWSDKData

public class LoginUseCase {

    private let authRepository: CWAuthRepository

    public init(authRepository: CWAuthRepository) {
        self.authRepository = authRepository
    }

    public func execute(_ query: CWLoginQuery) -> AnyPublisher<CWLoginEntity, Never> {
        return authRepository.login(query)
            .catch { error -> Just<CWLoginEntity> in
                return Just(CWLoginEntity(success: false, message: error.localizedDescription))
            }
            .eraseToAnyPublisher()
    }
}

//
//  IsAuthorisedUseCase.swift
//  CWSDKExample
//
//  Created by Sergey Muravev on 12.04.2022.
//

import Foundation
import Combine
import CWSDKData

public class IsAuthorisedUseCase {

    private let authRepository: CWAuthRepository

    public init(authRepository: CWAuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> AnyPublisher<Bool, Never> {
        Just(authRepository.isAuthorised)
            .eraseToAnyPublisher()
    }
}

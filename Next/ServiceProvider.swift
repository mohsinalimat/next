//
//  ServiceProvider.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

protocol ServiceFactory {
    func makeAuthService() -> AuthService
    func makeTaskService() -> TaskService
    func makeUserService() -> UserService
}

final class ServiceProvider: ServiceFactory {

    private let currentUser: User
    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func makeAuthService() -> AuthService {
        return FirebaseAuthService()
    }

    func makeTaskService() -> TaskService {
        return FirebaseTaskService(currentUser: currentUser)
    }

    func makeUserService() -> UserService {
        return FirebaseUserService()
    }
}

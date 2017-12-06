//
//  DependecyContainer.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

protocol ViewControllerFactory {
    func makeLoginViewController() -> UIViewController
    func makeCreateAccountViewController() -> UIViewController
}

protocol AuthServiceFactory {
    func makeAuthService() -> AuthService
}

final class DependencyContainer {}

extension DependencyContainer: AuthServiceFactory {
    func makeAuthService() -> AuthService {
        return FirebaseAuthService()
    }
}

extension DependencyContainer: ViewControllerFactory {
    func makeLoginViewController() -> UIViewController {
        guard let controller = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            fatalError("Could not instantite LoginViewController")
        }
        controller.configure(factory: self)
        return controller
    }

    func makeCreateAccountViewController() -> UIViewController {
        guard let controller = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateInitialViewController() as? CreateAccountViewController else {
            fatalError("Could not instantiate CreateAccountViewController")
        }
        controller.configure(factory: self)
        return controller
    }
}

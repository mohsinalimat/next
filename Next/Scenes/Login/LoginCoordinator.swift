//
//  LoginCoordinator.swift
//  Next
//
//  Created by Guilherme Souza on 18/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class LoginCoordinator: BaseCoordinator<User> {

    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> Observable<User> {
        let viewModel = LoginViewModel()
        let loginViewController = LoginViewController.instantiate()
        loginViewController.viewModel = viewModel
        navigationController.setViewControllers([loginViewController], animated: true)

        return viewModel.output.loggedIn.asObservable()
    }

}

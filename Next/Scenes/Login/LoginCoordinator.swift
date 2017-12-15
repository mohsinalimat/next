//
//  LoginCoordinator.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class LoginCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> Observable<Void> {
        let viewModel: LoginViewModelType = LoginViewModel()
        let loginViewController = LoginViewController.instantiate(with: viewModel)

        let loggedIn = viewModel.output.loggedIn

        return Observable.empty()
    }
}

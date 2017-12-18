//
//  AppCoordinator.swift
//  Next
//
//  Created by Guilherme Souza on 18/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {

    private let environment: Environment

    private let window: UIWindow
    init(
        window: UIWindow,
        environment: Environment = UserDefaultsEnvironment()
        ) {
        self.window = window
        self.environment = environment
    }

    override func start() -> Observable<Void> {
        let rootNavigationController = UINavigationController()
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()

        let listTaskCoordinator = ListTaskCoordinator(navigationController: rootNavigationController)
        return coordinate(to: listTaskCoordinator)
    }

}

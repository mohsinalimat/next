//
//  AppCoordinator.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let environment: Environment = UserDefaultsEnvironment()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let rootNavigationController = UINavigationController()
        
        if let currentUser = environment.getCurrentUser() {

        } else {
            let loginCoordinator = LoginCoordinator()
            return coordinate(to: loginCoordinator)
        }

        return Observable.never()
    }

}

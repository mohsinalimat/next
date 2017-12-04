//
//  RootNavigationController.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class RootNavigationController: UINavigationController {

    private let factory: ViewControllerFactory = DependencyContainer()

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([
            factory.makeLoginViewController()
            ], animated: true)
    }

}

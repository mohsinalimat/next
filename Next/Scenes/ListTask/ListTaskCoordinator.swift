//
//  ListTaskCoordinator.swift
//  Next
//
//  Created by Guilherme Souza on 18/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

final class ListTaskCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let currentUser: User
    init(
        navigationController: UINavigationController,
        currentUser: User
        ) {
        self.navigationController = navigationController
        self.currentUser = currentUser
    }

    override func start() -> Observable<Void> {
        let viewModel = ListTaskViewModel(taskService: FirebaseTaskService(currentUser: currentUser))
        let listTaskCollectionViewController = ListTaskCollectionViewController.instantiate(with: viewModel)

        navigationController.setViewControllers([listTaskCollectionViewController], animated: true)

        return Observable.never() // Return never because this is the root coordinator and it should never be freed.
    }
}

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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> Observable<Void> {
        let environment = UserDefaultsEnvironment()
        if let user = environment.getCurrentUser() {
            coordinateToListTaskController(with: user)
        } else {
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            coordinate(to: loginCoordinator)
                .do(onNext: { [weak self] user in self?.coordinateToListTaskController(with: user) })
                .subscribe()
                .disposed(by: disposeBag)
        }

        return Observable.never() // Return never because this is the root coordinator and it should never be freed.
    }

    private func coordinateToListTaskController(with user: User) {
        let viewModel = ListTaskViewModel(taskService: FirebaseTaskService(currentUser: user))
        let listTaskCollectionViewController = ListTaskCollectionViewController.instantiate(with: viewModel)
        navigationController.setViewControllers([listTaskCollectionViewController], animated: true)
    }
}

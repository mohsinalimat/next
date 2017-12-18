//
//  DependencyContainer.swift
//  Next
//
//  Created by Guilherme Souza on 16/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

protocol ViewControllerFactory {
//    func makeListTaskCollectionViewController() -> ListTaskCollectionViewController
    func makeAddTaskViewController() -> AddTaskViewController
}

protocol TaskServiceFactory {
    func makeTaskService() -> TaskService
}

final class DependencyContainer {
    private var currentUser: User

    init(user: User) {
        currentUser = user
    }

}

extension DependencyContainer: ViewControllerFactory {
//    func makeListTaskCollectionViewController() -> ListTaskCollectionViewController {
//        return ListTaskCollectionViewController.instantiate(factory: self)
//    }

    func makeAddTaskViewController() -> AddTaskViewController {
        return AddTaskViewController(factory: self)
    }
}

extension DependencyContainer: TaskServiceFactory {
    func makeTaskService() -> TaskService {
        return FirebaseTaskService(currentUser: currentUser)
    }
}

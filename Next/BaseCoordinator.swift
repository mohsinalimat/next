//
//  BaseCoordinator.swift
//  Next
//
//  Created by Guilherme Souza on 18/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator<ResultType> {
    typealias CoordinationResult = ResultType

    let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators: [UUID: Any] = [:]

    private func store<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    final func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator) })
    }

    @discardableResult
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented")
    }
}

//
//  ListTaskViewModel.swift
//  Next
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ListTaskViewModelInput {
    func viewDidAppear()
    func pullToRefresh()
}

protocol ListTaskViewModelOutput {
    var tasks: Driver<[TaskViewModel]> { get }
    var isLoading: Driver<Bool> { get }
}

protocol ListTaskViewModelType {
    var input: ListTaskViewModelInput { get }
    var output: ListTaskViewModelOutput { get }
}

final class ListTaskViewModel: ListTaskViewModelType, ListTaskViewModelInput, ListTaskViewModelOutput {
    let tasks: SharedSequence<DriverSharingStrategy, [TaskViewModel]>
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>

    init(taskService: TaskService) {
        let activityTracker = ActivityTracker()
        isLoading = activityTracker.asDriver()

        tasks = Observable.merge(viewDidAppearProperty, pullToRefreshProperty)
            .flatMap { _ in
                return taskService.getTasks()
                    .trackActivity(activityTracker)
            }
            .map { tasks in tasks.flatMap(TaskViewModel.init) }
            .asDriverOnErrorJustComplete()
    }

    private let viewDidAppearProperty = PublishSubject<Void>()
    func viewDidAppear() {
        viewDidAppearProperty.onNext(())
    }

    private let pullToRefreshProperty = PublishSubject<Void>()
    func pullToRefresh() {
        pullToRefreshProperty.onNext(())
    }

    var input: ListTaskViewModelInput { return self }
    var output: ListTaskViewModelOutput { return self }
}

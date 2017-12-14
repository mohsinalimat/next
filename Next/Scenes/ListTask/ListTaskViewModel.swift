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
}

protocol ListTaskViewModelOutput {
    var tasks: Driver<[TaskViewModel]> { get }
}

protocol ListTaskViewModelType {
    var input: ListTaskViewModelInput { get }
    var output: ListTaskViewModelOutput { get }
}

final class ListTaskViewModel: ListTaskViewModelType, ListTaskViewModelInput, ListTaskViewModelOutput {
    let tasks: SharedSequence<DriverSharingStrategy, [TaskViewModel]>

    init(taskService: TaskService) {
        tasks = viewDidAppearProperty.withLatestFrom(taskService.getTasks())
            .map { tasks in tasks.flatMap(TaskViewModel.init) }
            .asDriverOnErrorJustComplete()
    }

    private let viewDidAppearProperty = PublishSubject<Void>()
    func viewDidAppear() {
        viewDidAppearProperty.onNext(())
    }

    var input: ListTaskViewModelInput { return self }
    var output: ListTaskViewModelOutput { return self }
}

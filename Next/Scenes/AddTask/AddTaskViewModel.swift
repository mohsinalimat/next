//
//  AddTaskViewModel.swift
//  Next
//
//  Created by Guilherme Souza on 16/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddTaskViewModelInput {
    func saveTapped()
    func detailChanged(_ value: String?)
}

protocol AddTaskViewModelOutput {
    var taskCreated: Driver<Void> { get }
}

protocol AddTaskViewModelType {
    var input: AddTaskViewModelInput { get }
    var output: AddTaskViewModelOutput { get }
}

final class AddTaskViewModel: AddTaskViewModelType, AddTaskViewModelInput, AddTaskViewModelOutput {

    let taskCreated: SharedSequence<DriverSharingStrategy, Void>

    init(taskService: TaskService) {
        let detail = detailProperty.asDriverOnErrorJustComplete().skipNil()

        taskCreated = saveTappedProperty.withLatestFrom(detail)
            .flatMap { detail in taskService.create(detail: detail) }
            .asDriverOnErrorJustComplete()
            .mapToVoid()
    }

    private let saveTappedProperty = PublishSubject<Void>()
    func saveTapped() {
        saveTappedProperty.onNext(())
    }

    private let detailProperty = PublishSubject<String?>()
    func detailChanged(_ value: String?) {
        detailProperty.onNext(value)
    }

    var input: AddTaskViewModelInput { return self }
    var output: AddTaskViewModelOutput { return self }
}

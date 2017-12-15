//
//  AddTaskViewModel.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddTaskViewModelInput {
    func saveTapped()
}

protocol AddTaskViewModelOutput {}

protocol AddTaskViewModelType {
    var input: AddTaskViewModelInput { get }
    var output: AddTaskViewModelOutput { get }
}

final class AddTaskViewModel: AddTaskViewModelType, AddTaskViewModelInput, AddTaskViewModelOutput {

    init(taskService: TaskService) {

    }

    private let saveTappedProperty = PublishSubject<Void>()
    func saveTapped() {
        saveTappedProperty.onNext(())
    }

    var input: AddTaskViewModelInput { return self }
    var output: AddTaskViewModelOutput { return self }
}

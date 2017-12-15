//
//  AddTaskViewController.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class AddTaskViewController: UIViewController {

//    private var serviceProvider: ServiceProvider

    private lazy var viewModel: AddTaskViewModelType = AddTaskViewModel(taskService: FirebaseTaskService())
    private let disposeBag = DisposeBag()

    static func instantiate() -> AddTaskViewController {
        return Storyboard.AddTask.instantiate(AddTaskViewController.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
        bindViewModel()
    }

    private func bindViewModel() {}

    @objc private func saveButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.input.saveTapped()
    }

}

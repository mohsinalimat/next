//
//  AddTaskViewController.swift
//  Next
//
//  Created by Guilherme Souza on 16/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class AddTaskViewController: UIViewController {

    @IBOutlet private weak var detailTextField: UITextField!

    private lazy var viewModel: AddTaskViewModelType = AddTaskViewModel(taskService: factory.makeTaskService())
    private let disposeBag = DisposeBag()

    typealias Factory = TaskServiceFactory
    private let factory: Factory

    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(_:)))
        detailTextField.addTarget(self, action: #selector(detailTextFieldChanged(_:)), for: .editingChanged)
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.output.taskCreated
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    @objc private func saveTapped(_ sender: UIBarButtonItem) {
        viewModel.input.saveTapped()
    }

    @objc private func detailTextFieldChanged(_ sender: UITextField) {
        viewModel.input.detailChanged(sender.text)
    }

}

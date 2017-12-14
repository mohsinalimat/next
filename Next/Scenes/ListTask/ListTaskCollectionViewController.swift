//
//  ListTaskCollectionViewController.swift
//  Next
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit

final class TaskViewModel: ListDiffable {
    let id: String
    let detail: String

    init?(task: Task) {
        guard let id = task.id,
            let detail = task.detail else { return nil }

        self.id = id
        self.detail = detail
    }

    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? TaskViewModel {
            return object.id == id &&
                object.detail == detail
        }
        return false
    }
}

final class ListTaskCollectionViewController: UICollectionViewController {

    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    private lazy var viewModel: ListTaskViewModelType! = ListTaskViewModel(
        taskService: FirebaseTaskService(currentUser: self.user)
    )
    private let disposeBag = DisposeBag()

    private var objects: [TaskViewModel] = []

    static func instantiate(withUser user: User) -> ListTaskCollectionViewController {
        let controller = Storyboard.ListTask.instantiate(ListTaskCollectionViewController.self)
        controller.configure(withUser: user)
        return controller
    }

    private var user: User!
    private func configure(withUser user: User) {
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutTapped(_:)))
        adapter.collectionView = collectionView
        adapter.dataSource = self
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.viewDidAppear()
    }

    private func bindViewModel() {
        viewModel.output.tasks
            .drive(onNext: { [weak self] tasks in
                self?.objects = tasks
                self?.adapter.performUpdates(animated: true)
            })
            .disposed(by: disposeBag)
    }

    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        print("Add")
    }

    @objc private func signOutTapped(_ sender: UIBarButtonItem) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.signOut()
        }
    }
}

// MARK: ListAdapterDataSource
extension ListTaskCollectionViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListTaskSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


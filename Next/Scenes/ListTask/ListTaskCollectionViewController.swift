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

    init(task: Task) {
        id = task.id
        detail = task.detail
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

    private let viewModel: ListTaskViewModelType = ListTaskViewModel()
    private let disposeBag = DisposeBag()

    private var objects: [TaskViewModel] = []

    static func instantiate() -> ListTaskCollectionViewController {
        return Storyboard.ListTask.instantiate(ListTaskCollectionViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Tasks"
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


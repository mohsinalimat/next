//
//  TaskService.swift
//  Next
//
//  Created by Guilherme Souza on 07/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

protocol TaskService {
    func create(detail: String) -> Observable<Task>
    func getTasks() -> Observable<[Task]>
}

struct FirebaseTaskService: TaskService {
    private enum Keys: String {
        case tasks
        case users
        case taskUsers = "task-users"
    }

    private let currentUser: User
    private let ref = Database.database().reference()

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func getTasks() -> Observable<[Task]> {
        return Database.database().reference()
            .child(Keys.taskUsers.rawValue)
            .child(self.currentUser.uid)
            .rx.observe(.value)
            .flatMap { snapshot -> Observable<[Task]> in
                if let value = snapshot.value as? [String: Any] {
                    let keys = [String](value.keys)
                    let tasks = keys.flatMap(self.getTask)
                    return Observable.combineLatest(tasks)
                }
                return Observable.just([])
        }
    }

    private func getTask(uid: String) -> Observable<Task> {
        return Database.database().reference()
            .child(Keys.tasks.rawValue)
            .child(uid)
            .rx.observeSingleEvent(of: .value)
            .flatMap { snapshot -> Observable<Task> in
                if let value = snapshot.value as? [String: Any],
                    let task = Task(from: value) {
                    return Observable.just(task)
                }
                return Observable.empty()
        }
    }

    func create(detail: String) -> Observable<Task> {
        let uid = Database.database().reference().child(Keys.tasks.rawValue).childByAutoId().key
        let task = Task(uid: uid, detail: detail)
        return save(task)
            .map { _ in task }
    }

    private func save(_ task: Task) -> Observable<Void> {
        let saveTask = Database.database().reference()
            .child(Keys.tasks.rawValue)
            .child(task.uid)
            .rx.updateChildValues(task.asJSON())
            .mapToVoid()

        let addTask = addTaskToUser(withUid: task.uid)

        return Observable.merge(saveTask, addTask)
    }

    private func addTaskToUser(withUid uid: String) -> Observable<Void> {
        return Database.database().reference()
            .child(Keys.taskUsers.rawValue)
            .child(self.currentUser.uid)
            .child(uid)
            .rx.setValue(true)
            .mapToVoid()
    }
}

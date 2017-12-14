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
    func getTasks() -> Observable<[Task]>
}

struct FirebaseTaskService: TaskService {
    private enum Keys: String {
        case tasks
        case users
    }

    private let currentUser: User
    private let ref = Database.database().reference()

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func getTasks() -> Observable<[Task]> {
        return Observable.create { observer in
            let handle = self.ref
                .child(Keys.users.rawValue)
                .child(self.currentUser.uid)
                .child(Keys.tasks.rawValue)
                .observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? [[String: Any]] {
                    print(value)
                }
            })

            return Disposables.create {
                Database.database().reference().removeObserver(withHandle: handle)
            }
        }
    }

    func save(_ task: Task) -> Observable<Void> {
        return Observable.create { observer in
            let ref = Database.database().reference().child(Keys.tasks.rawValue).childByAutoId()
            ref.updateChildValues(task.asJSON(), withCompletionBlock: { (error, _) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                }
                observer.onCompleted()
            })

            return Disposables.create()
        }
    }
}

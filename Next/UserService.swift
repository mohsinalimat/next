//
//  UserService.swift
//  Next
//
//  Created by Guilherme Souza on 07/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

protocol UserService {
    func save(_ user: User) -> Observable<User>
    func get(uid: String) -> Observable<User?>
}

struct FirebaseUserService: UserService {
    func get(uid: String) -> Observable<User?> {
        return Observable.create { observer in
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? [AnyHashable: Any] {
                    let user = User(json: value)
                    observer.onNext(user)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            })

            return Disposables.create()
        }
    }

    func save(_ user: User) -> Observable<User> {
        return Observable.create { observer in
            Database.database().reference().child("users").child(user.uid).updateChildValues(user.asJSON()) { (error, _) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(user)
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}

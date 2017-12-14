//
//  UserServiceMock.swift
//  NextTests
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

@testable import Next

struct UserServiceMock: UserService {
    func get(uid: String) -> Observable<User?> {
        return Observable.just(User(uid: uid, name: nil, email: "\(uid)@gmail.com"))
    }

    func save(_ user: User) -> Observable<User> {
        return Observable.just(user)
    }
}

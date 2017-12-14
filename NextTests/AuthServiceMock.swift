//
//  AuthServiceMock.swift
//  NextTests
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

@testable import Next

struct AuthServiceMock: AuthService {
    func currentLoggedUser() -> Observable<User?> {
        return Observable.just(User(uid: "12345", name: nil, email: "12345@gmail.com"))
    }

    func login(email: String, password: String) -> Observable<User> {
        return Observable.just(User(uid: "12345", name: nil, email: email))
    }

    func createAccount(name: String, email: String, password: String) -> Observable<User> {
        return Observable.just(User(uid: "12345", name: name, email: email))
    }
}

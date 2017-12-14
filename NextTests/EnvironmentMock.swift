//
//  EnvironmentMock.swift
//  NextTests
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
@testable import Next

private var localCache: [String: Any] = [:]

struct EnvironmentMock: Environment {

    func getCurrentUser() -> User? {
        return localCache["currentUser"] as? User
    }

    func saveCurrentUser(_ currentUser: User) {
        localCache["currentUser"] = currentUser
    }
}

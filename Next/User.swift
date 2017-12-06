//
//  User.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let name: String?
    let email: String
}

extension User {
    init(user: Firebase.User) {
        uid = user.uid
        name = user.displayName
        email = user.email ?? ""
    }
}

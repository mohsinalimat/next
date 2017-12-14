//
//  User.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Firebase

struct User: Codable {
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

    init?(json: [AnyHashable: Any]) {
        guard let uid = json["uid"] as? String,
            let email = json["email"] as? String else { return nil }
        self.uid = uid
        self.email = email
        self.name = json["name"] as? String
    }
}

extension User {
    func asJSON() -> [AnyHashable: Any] {
        var json: [AnyHashable: Any] = [:]
        json[CodingKeys.uid.stringValue] = uid
        json[CodingKeys.email.stringValue] = email
        json[CodingKeys.name.stringValue] = name
        return json
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.email == rhs.email &&
            lhs.name == rhs.name
    }
}

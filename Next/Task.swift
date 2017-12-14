//
//  Task.swift
//  Next
//
//  Created by Guilherme Souza on 07/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Task: Codable {
    let uid: String
    let detail: String

    init(detail: String) {
        uid = Database.database().reference().childByAutoId().key
        self.detail = detail
    }

    init?(from json: [String: Any]) {
        guard let uid = json["uid"] as? String,
            let detail = json["detail"] as? String else { return nil }

        self.uid = uid
        self.detail = detail
    }
}

extension Task {
    func asJSON() -> [AnyHashable: Any] {
        return [
            CodingKeys.uid.stringValue: uid,
            CodingKeys.detail.stringValue: detail
        ]
    }
}

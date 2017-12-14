//
//  Task.swift
//  Next
//
//  Created by Guilherme Souza on 07/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Task {
    let id: String?
    let detail: String?
}

extension Task {
    func asJSON() -> [AnyHashable: Any] {
        return [:]
    }
}

//
//  JSONRepresentable.swift
//  Next
//
//  Created by Guilherme Souza on 16/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

protocol JSONRepresentable {
    init?(from json: [String: Any])
    func asJSON() -> [String: Any]
}

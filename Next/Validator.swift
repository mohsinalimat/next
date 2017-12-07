//
//  Validator.swift
//  Next
//
//  Created by Guilherme Souza on 05/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Validator {
    static func isEmailValid(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    static func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 6
    }
}

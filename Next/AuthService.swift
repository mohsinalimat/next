//
//  AuthService.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Result
import FirebaseAuth
import Firebase

enum AuthError: Error {
    case userNotFound
    case invalidEmail
    case wrongPassword
    case userDisabled
    case unknown
}

protocol AuthService {
    func login(email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void)
}

struct FirebaseAuthService: AuthService {
    private let auth = Auth.auth()

    func login(email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error as NSError?,
                let errorCode = AuthErrorCode(rawValue: error.code) {
                let error = self.authError(from: errorCode)
                completion(.failure(error))
            } else if let user = user {
                completion(.success(User(user: user)))
            } else {
                completion(.failure(AuthError.unknown))
            }
        }
    }

    private func authError(from code: AuthErrorCode) -> AuthError {
        switch code {
        case .userNotFound:
            return .userNotFound
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .wrongPassword
        case .userDisabled:
            return .userDisabled
        default:
            return .unknown
        }
    }
}

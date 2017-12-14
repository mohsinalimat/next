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
import RxSwift

enum AuthError: Error {
    case userNotFound
    case invalidEmail
    case wrongPassword
    case userDisabled
    case unknown
}

protocol AuthService {
    func currentLoggedUser() -> Observable<User?>
    func login(email: String, password: String) -> Observable<User>
    func createAccount(name: String, email: String, password: String) -> Observable<User>
    func signOut() -> Observable<Void>
}

struct FirebaseAuthService: AuthService {
    func currentLoggedUser() -> Observable<User?> {
        if let user = Auth.auth().currentUser {
            return Observable.just(User(user: user))
        }
        return Observable.just(nil)
    }
    
    func login(email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error as NSError?,
                    let errorCode = AuthErrorCode(rawValue: error.code) {
                    let error = self.authError(from: errorCode)
                    observer.onError(error)
                } else if let user = user {
                    observer.onNext(User(user: user))
                } else {
                    observer.onError(AuthError.unknown)
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    func createAccount(name: String, email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error as NSError?,
                    let errorCode = AuthErrorCode(rawValue: error.code) {
                    let error = self.authError(from: errorCode)
                    observer.onError(error)
                } else if let user = user {
                    observer.onNext(User(user: user))
                } else {
                    observer.onError(AuthError.unknown)
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    func signOut() -> Observable<Void> {
        return Observable.create { observer in
            do {
                try Auth.auth().signOut()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
                    let error = self.authError(from: errorCode) // TODO: Must research which errors can be thrown here.
                    observer.onError(error)
                } else {
                    observer.onError(AuthError.unknown)
                }
            }
            return Disposables.create()
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

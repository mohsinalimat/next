//
//  LoginViewModel.swift
//  Next
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    func loginTapped()
    func emailChanged(_ value: String?)
    func passwordChanged(_ value: String?)
}

protocol LoginViewModelOutput {
    var error: Driver<Error> { get }
    var loggedIn: Driver<User> { get }
    var isButtonEnabled: Driver<Bool> { get }
    var isLoading: Driver<Bool> { get }
}

protocol LoginViewModelType {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelInput, LoginViewModelOutput {
    
    let error: SharedSequence<DriverSharingStrategy, Error>
    let loggedIn: SharedSequence<DriverSharingStrategy, User>
    let isButtonEnabled: SharedSequence<DriverSharingStrategy, Bool>
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    
    init(authService: AuthService, userService: UserService, environment: Environment) {
        let emailAndPassword = Driver.combineLatest(
            emailProperty.asDriverOnErrorJustComplete().skipNil(),
            passwordProperty.asDriverOnErrorJustComplete().skipNil()
        ) { (email: $0, password: $1) }
        
        let errorTracker = ErrorTracker()
        error = errorTracker.asDriver()

        let activityTracker = ActivityTracker()
        isLoading = activityTracker.asDriver()
        
        isButtonEnabled = Driver.merge(
            Driver.of(false),
            emailAndPassword.map(validateFields)
            )
            .asDriver()
        
        loggedIn = loginTappedProperty.withLatestFrom(emailAndPassword)
            .flatMapLatest { user in
                return authService.login(email: user.email, password: user.password)
                    .flatMap(userService.save)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .do(onNext: environment.saveCurrentUser)
            }
            .asDriverOnErrorJustComplete()
    }
    
    private let loginTappedProperty = PublishSubject<Void>()
    func loginTapped() {
        loginTappedProperty.onNext(())
    }
    
    private let emailProperty = PublishSubject<String?>()
    func emailChanged(_ value: String?) {
        emailProperty.onNext(value)
    }
    
    private let passwordProperty = PublishSubject<String?>()
    func passwordChanged(_ value: String?) {
        passwordProperty.onNext(value)
    }
    
    var input: LoginViewModelInput { return self }
    var output: LoginViewModelOutput { return self }
}

private func validateFields(email: String, password: String) -> Bool {
    return Validator.isEmailValid(email) && Validator.isPasswordValid(password)
}

//
//  LoginViewModelTest.swift
//  NextTests
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
import RxCocoa
import RxTest

@testable import Next

final class LoginViewModelTest: XCTestCase {
    
    private var vm: LoginViewModelType!
    private var disposeBag: DisposeBag!
    private var isButtonEnabled: TestableObserver<Bool>!
    private var loggedIn: TestableObserver<Void>!
    
    override func setUp() {
        super.setUp()
        vm = LoginViewModel(authService: AuthServiceMock())
        disposeBag = DisposeBag()
      
        let scheduler = TestScheduler(initialClock: 0)
        isButtonEnabled = scheduler.createObserver(Bool.self)
        loggedIn = scheduler.createObserver(Void.self)
        
        vm.output.isButtonEnabled.drive(self.isButtonEnabled).disposed(by: disposeBag)
        vm.output.loggedIn.drive(self.loggedIn).disposed(by: disposeBag)
        
        scheduler.start()
    }
    
    func test_shouldDisableLogin_whenEmailIsEmpty() {
        vm.input.emailChanged("")
        
        let expected = [
            next(0, false)
        ]
        
        XCTAssertEqual(isButtonEnabled.events, expected)
    }
    
    func test_shouldDisableLogin_whenPasswordIsEmpty() {
        vm.input.passwordChanged("")
        
        let expected = [
            next(0, false)
        ]
        
        XCTAssertEqual(isButtonEnabled.events, expected)
    }
    
    func test_shouldDisableLogin_whenEmailIsInvalid() {
        vm.input.emailChanged("invalid_email")
        vm.input.passwordChanged("validpassword123")
        
        let expected = [
            next(0, false),
            next(0, false)
        ]
        
        XCTAssertEqual(isButtonEnabled.events, expected)
    }
    
    func test_shouldDisableLogin_whenPasswordIsInvalid() {
        vm.input.emailChanged("guilherme@gmail.com")
        vm.input.passwordChanged("wrong")
        
        let expected = [
            next(0, false),
            next(0, false)
        ]
        
        XCTAssertEqual(isButtonEnabled.events, expected)
    }
    
    func test_shoudlEnableLogin_whenBothEmailAndPasswordAreValid() {
        vm.input.emailChanged("guilherme@gmail.com")
        vm.input.passwordChanged("validpassword")
        
        let expected = [
            next(0, false),
            next(0, true)
        ]
        
        XCTAssertEqual(isButtonEnabled.events, expected)
    }
    
    func test_shouldLogin_whenButtonTapWithValidInputs() {
        vm.input.emailChanged("guilherme@gmail.com")
        vm.input.passwordChanged("validpassword")
        vm.input.loginTapped()
        
        let expected = [
            next(0, ())
        ]
        
        XCTAssertEqual(loggedIn.events.count, expected.count)
    }
}

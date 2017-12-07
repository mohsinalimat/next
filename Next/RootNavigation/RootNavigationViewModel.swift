//
//  RootNavigationViewModel.swift
//  Next
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RootNavigationViewModelInput {
    func viewDidLoad()
}

protocol RootNavigationViewModelOutput {
    var isUserLoggedIn: Driver<Bool> { get }
}

protocol RootNavigationViewModelType {
    var input: RootNavigationViewModelInput { get }
    var output: RootNavigationViewModelOutput { get }
}

final class RootNavigationViewModel: RootNavigationViewModelType, RootNavigationViewModelInput, RootNavigationViewModelOutput {
    
    let isUserLoggedIn: SharedSequence<DriverSharingStrategy, Bool>
    
    init(authService: AuthService) {
        isUserLoggedIn = viewDidLoadProperty
            .flatMap { _ in
                return authService.currentLoggedUser()
                    .map { user in user == nil ? false : true }
            }
            .asDriverOnErrorJustComplete()
    }
    
    private let viewDidLoadProperty = PublishSubject<Void>()
    func viewDidLoad() {
        viewDidLoadProperty.onNext(())
    }
    
    var input: RootNavigationViewModelInput { return self }
    var output: RootNavigationViewModelOutput { return self }
}

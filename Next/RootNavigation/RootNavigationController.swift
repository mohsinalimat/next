//
//  RootNavigationController.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class RootNavigationController: UINavigationController {

    private let viewModel: RootNavigationViewModelType = RootNavigationViewModel(authService: FirebaseAuthService())
    private let disposeBag = DisposeBag()

    static func instantiate() -> RootNavigationController {
        return Storyboard.Main.instantiate(RootNavigationController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        viewModel.input.viewDidLoad()
//        
//        viewModel.output.isUserLoggedIn
//            .drive(onNext: { [weak self] isLoggedIn in
//                if isLoggedIn {
//                    self?.startTaskListFlow()
//                } else {
//                    self?.startLoginFlow()
//                }
//            })
//            .disposed(by: disposeBag)
    }
    
    private func startLoginFlow() {
        present(LoginViewController.instantiate(), animated: true, completion: nil)
    }
    
    private func startTaskListFlow() {
        present(ListTaskCollectionViewController.instantiate(), animated: true, completion: nil)
    }

}

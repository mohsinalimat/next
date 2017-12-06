//
//  CreateAccountViewController.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class CreateAccountViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    typealias Factory = AuthServiceFactory

    private var factory: Factory!
    private lazy var authService = factory.makeAuthService()

    func configure(factory: Factory) {
        self.factory = factory
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func createAccountTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }

        authService.createAccount(name: name, email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.showAlert(
                    title: "Success",
                    message: "Account created with email '\(user.email)'.",
                    completion: { self?.dismiss() }
                )
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction private func signInTapped(_ sender: UIButton) {
        dismiss()
    }
}

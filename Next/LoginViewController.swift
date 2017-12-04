//
//  ViewController.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    private enum TextFieldTag: Int {
        case email, password
    }

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    typealias Factory = ViewControllerFactory & AuthServiceFactory
    private var factory: Factory!

    private lazy var authService = factory.makeAuthService()

    func configure(factory: Factory) {
        self.factory = factory
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.tag = TextFieldTag.email.rawValue

        passwordTextField.delegate = self
        passwordTextField.tag = TextFieldTag.password.rawValue

        addKeyboardNotifications()
    }

    private func makeLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }

        // TODO: validate email and password
        authService.login(email: email, password: password) { (result) in
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction private func loginTapped(_ sender: UIButton) {
        makeLogin()
    }

    // MARK: - Keyboard Notifications

    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scrollRectToVisible(textField.frame, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TextFieldTag.password.rawValue {
            makeLogin()
        } else {
            view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        }
        return true
    }
}


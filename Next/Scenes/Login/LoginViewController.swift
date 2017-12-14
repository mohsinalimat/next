//
//  ViewController.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {

    private enum Constants {
        static let defaultBottomSpacing: CGFloat = 16
        static let scrollViewBottomInsetGap: CGFloat = 32
    }

    private enum TextFieldTag: Int {
        case email, password
    }

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var createAccountButtonBottomMarginConstraint: NSLayoutConstraint!

    private lazy var viewModel: LoginViewModelType = LoginViewModel(
        authService: FirebaseAuthService(),
        userService: FirebaseUserService(),
        environment: UserDefaultsEnvironment()
    )

    private let disposeBag = DisposeBag()
    
    static func instantiate() -> LoginViewController {
        return Storyboard.Login.instantiate(LoginViewController.self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.tag = TextFieldTag.email.rawValue
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)

        passwordTextField.delegate = self
        passwordTextField.tag = TextFieldTag.password.rawValue
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged(_:)), for: .editingChanged)

        addKeyboardNotifications()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.output.isButtonEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .drive(activityIndicator.rx.isAnimating, loginButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.isLoading.not()
            .drive(view.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)

        viewModel.output.loggedIn
            .drive(onNext: { [weak self] user in
                self?.startListTaskController(withUser: user)
            })
            .disposed(by: disposeBag)

        viewModel.output.error
            .drive(onNext: handleError)
            .disposed(by: disposeBag)
    }

    private func handleError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    private func startListTaskController(withUser user: User) {
        let navigationController = RootNavigationController.instantiate()
        navigationController.setViewControllers([ListTaskCollectionViewController.instantiate(withUser: user)], animated: false)
        present(navigationController, animated: true)
    }

    @objc private func emailTextFieldChanged(_ textField: UITextField) {
        viewModel.input.emailChanged(textField.text)
    }

    @objc private func passwordTextFieldChanged(_ textField: UITextField) {
        viewModel.input.passwordChanged(textField.text)
    }

    @IBAction private func loginTapped(_ sender: UIButton) {
        viewModel.input.loginTapped()
    }

    @IBAction private func createAccountTapped(_ sender: UIButton) {
        let createAccountViewController = CreateAccountViewController.instantiate()
        navigationController?.pushViewController(createAccountViewController, animated: true)
    }

    // MARK: - Keyboard Notifications

    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            scrollView.contentInset.bottom = keyboardSize.height + Constants.scrollViewBottomInsetGap
            view.layoutIfNeeded()
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.createAccountButtonBottomMarginConstraint.constant = keyboardSize.height + Constants.defaultBottomSpacing
                self.scrollView.scrollToBottom(animated: false)
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardAnimationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            view.layoutIfNeeded()
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.createAccountButtonBottomMarginConstraint.constant = Constants.defaultBottomSpacing
                self.scrollView.contentInset = .zero
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scrollRectToVisible(textField.frame, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TextFieldTag.password.rawValue {
            viewModel.input.loginTapped()
        } else {
            view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        }
        return true
    }
}


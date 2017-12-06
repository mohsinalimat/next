//
//  UIViewController+showAlert.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, actionTitle: String = "Ok", completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

}

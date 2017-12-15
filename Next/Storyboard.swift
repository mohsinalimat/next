//
//  Storyboard.swift
//  Next
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case Main
    case Login
    case ListTask
    case CreateAccount
    case AddTask
    
    func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: nil).instantiateInitialViewController() as? VC else {
            fatalError("Could not instantiate \(String(describing: VC.self)) from \(self.rawValue)")
        }
        return vc
    }
}

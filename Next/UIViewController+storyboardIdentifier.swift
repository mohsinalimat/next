//
//  UIViewController+storyboardIdentifier.swift
//  Next
//
//  Created by Guilherme Souza on 06/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
}

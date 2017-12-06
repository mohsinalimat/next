//
//  UIScrollView+scrollToBottom.swift
//  Next
//
//  Created by Guilherme Souza on 04/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        scrollRectToVisible(
            CGRect(
                x: contentSize.width - 1,
                y: contentSize.height - 1,
                width: 1,
                height: 1
        ), animated: false)
    }
}

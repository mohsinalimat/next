//
//  EmptyListView.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class EmptyListView: UIView {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var value: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    static func instantiate(with value: String?) -> EmptyListView {
        let view = EmptyListView()
        view.value = value
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        NSLayoutConstraint.activate(
            [
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
                label.rightAnchor.constraint(equalTo: rightAnchor, constant: -32)
            ]
        )
    }
}

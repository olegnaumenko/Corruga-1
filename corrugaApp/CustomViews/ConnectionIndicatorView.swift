//
//  ConnectionIndicatorView.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/30/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

class ConnectionIndicatorView: UIView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = .red
        self.alpha = 0.75
        label.textColor = .white
        label.textAlignment = .center
        label.text = "reachability-indicator-text".n10
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

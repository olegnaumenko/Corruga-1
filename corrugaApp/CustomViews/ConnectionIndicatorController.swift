//
//  ConnectionView.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/30/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

final class ConnectionIndicatorController: NSObject {

    private let indicatorHeight:CGFloat = 48
    private let parentViewController:UIViewController
    private lazy var indicatorView:UIView = ConnectionIndicatorView()
    private var isShown:Bool = false
    
    private var topConstraint:NSLayoutConstraint?
    
    init(parentViewController:UIViewController) {
        self.parentViewController = parentViewController
        super.init()
    }
    
    func set(visibility:Bool) {
    
        guard let superview = self.parentViewController.view else {
            return
        }
        
        var isChange = false
        var isRemove = false
        var offset:CGFloat = 0
        if self.indicatorView.superview == nil && visibility == true {
            isChange = true
            self.layout(on: superview)
            self.indicatorView.layoutIfNeeded()
        } else if self.indicatorView.superview != nil && visibility == false {
            isChange = true
            isRemove = true
            offset = indicatorHeight;
        }
        if isChange {
            UIView.animate(withDuration: 2.3, animations: {
                self.topConstraint?.constant = offset
                self.indicatorView.layoutIfNeeded()
            }, completion: { (success) in
                if isRemove && success {
                    self.indicatorView.removeFromSuperview()
                }
            })
        }
        
    }
    
    private func layout(on superview:UIView) {
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self.indicatorView)
        self.topConstraint = self.indicatorView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0)
        self.topConstraint?.isActive = true
        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: indicatorHeight)
        ])
    }
}

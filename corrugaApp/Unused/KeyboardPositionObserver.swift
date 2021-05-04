//
//  KeyboardPositionObserver.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/17/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class KeyboardPositionObserver:NSObject
{
    typealias KeyboardHeightBlock = (CGFloat)->()

    private let onKeyboardHeightChange:KeyboardHeightBlock
    
    init(onHeightChange:@escaping KeyboardHeightBlock) {
        
        self.onKeyboardHeightChange = onHeightChange
        super.init()
        NotificationCenter.default.addObserver(self,
                               selector: #selector(KeyboardPositionObserver.keyboardWillShow(n:)),
                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                               selector: #selector(KeyboardPositionObserver.keyboardWillHide),
                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func keyboardWillShow(n:Notification) {
        if let value = n.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let rect = value.cgRectValue
            self.onKeyboardHeightChange(rect.size.height)
        }
    }
    
    @objc private func keyboardWillHide() {
        self.onKeyboardHeightChange(0.0)
    }
}

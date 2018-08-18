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
                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                               selector: #selector(KeyboardPositionObserver.keyboardWillHide),
                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardWillShow(n:Notification) {
        if let value = n.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let rect = value.cgRectValue
            self.onKeyboardHeightChange(rect.size.height)
        }
    }
    
    func keyboardWillHide() {
        self.onKeyboardHeightChange(0.0)
    }
}

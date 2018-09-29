//
//  FloatingHeaderPresenter.swift
//  Vox-iOS
//
//  Created by Oleg Naumenko on 4/25/16.
//  Copyright © 2016 Coppertino Inc. All rights reserved.
//

import Foundation
import UIKit

@objc class FloatingHeaderPresenter:NSObject {
    
    let shownPositionY:CGFloat
    let contentView:UIView
    var observerId:String?
    
    var oldOffsetY:CGFloat = 0.0
    var cumulDelta:Float = 0.0
    var animating = false
    var hidden = false
    
    
    init(contentView:UIView, shownPositionY:CGFloat = 0.0) {
        
        self.shownPositionY = shownPositionY
        self.contentView = contentView
    }
    
    var scrollView:UIScrollView? {
        willSet {
            if self.scrollView != nil && self.observerId != nil {
//                self.scrollView!.bk_removeObservers(withIdentifier: self.observerId)
                self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
                self.observerId = nil
            }
        }
        didSet {
            
            guard let scrollView = self.scrollView else {
                return
            }
            
            self.oldOffsetY = scrollView.contentOffset.y
            self.cumulDelta = 0.0
            self.animating = false
            self.hidden = false
            
            var frame = self.contentView.frame
            frame.origin.y = self.shownPositionY
            self.contentView.frame = frame
            
            self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        }
        
    }
                                        
    func observeContentOffset(obj:Any?)
    {
        if let tView = obj as? UIScrollView {
            let offset = tView.contentOffset.y
            let delta = Float(offset - oldOffsetY)
            var direction:Int = 0
            if delta > 0.01 && !hidden {
                cumulDelta += delta
                if (cumulDelta > 5) {
                    direction = -1 //hide
                    cumulDelta = 0.0
                }
            } else if delta < -0.001 && hidden {
                direction = 1 // show
                cumulDelta = 0.0
            }
            oldOffsetY = offset
            
            let isTopEdgeCondition = -offset > tView.contentInset.top && direction == -1;
            
            
            if direction == -1 && animating == false && isTopEdgeCondition == false {
                
                var frame = self.contentView.frame
                
                if frame.size.height > -frame.origin.y {
                    frame.origin.y -= min(CGFloat(delta), frame.size.height)
                    self.contentView.frame = frame
                } else {
                    
                    self.hidden = true
                }
            }
            
            else if direction != 0 && animating == false && isTopEdgeCondition == false {
                
                let shouldShow:Bool = (direction == 1)
                
                let top = (shouldShow ? self.shownPositionY : self.shownPositionY - self.contentView.frame.size.height)
                
//                let alpha = (shouldShow ? 1.0:0.0)
                
                var frame = self.contentView.frame
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.animating = true
                    frame.origin.y = top
                    self.contentView.frame = frame
//                    self.contentView.alpha = CGFloat(alpha)
                    
                }, completion: { (finished:Bool) in
                    self.animating = false
                    self.hidden = (direction == -1)
                })
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "contentOffset") {
            self.observeContentOffset(obj: object)
        }
    }
}

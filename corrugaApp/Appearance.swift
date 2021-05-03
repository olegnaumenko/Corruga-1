//
//  Appearance.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

@objc @objcMembers class Appearance:NSObject
{
    static func backgroundAppColor() -> UIColor {
        return UIColor(named: "app-background")!
    }
    
    static func secondaryBackgroundAppColor() -> UIColor {
        return UIColor(named: "app-background-secondary")!
    }
    
    static func appTintColor() -> UIColor {
        return UIColor(named: "app-tint")!
    }
    
    static func appTintLargeColor() -> UIColor {
        return UIColor(named: "app-tint-large")!
    }
    
    static func topButtonTint() -> UIColor {
        return self.backgroundAppColor()
    }
    
    static let labelColor = UIColor(named: "app-label")!
    
    static func labelSecondaryColor() -> UIColor {
        return UIColor(named: "app-secondary-label")!
    }
    
    static func inactiveTintColor() -> UIColor {
        return UIColor(named: "app-secondary-label")!
    }
    
    static func footerTextColor() -> UIColor {
        return self.labelSecondaryColor()
    }
    
    static func footerBackgroundColor() -> UIColor {
        return UIColor(named: "footer-background")!
    }
    
    static func darkAppColor() -> UIColor {
        return UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    }
    
    static func highlightedTextColor() -> UIColor {
        return UIColor(red: 1, green: 1, blue: 0, alpha: 0.3)
    }
    
    static func footerFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    static func setPageIndicatorColor() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = appTintColor()
        appearance.backgroundColor = backgroundAppColor()
    }
}

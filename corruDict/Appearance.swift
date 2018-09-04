//
//  Appearance.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class Appearance
{
    static let kMainStoryboardName = "Main"
    
    static func basicAppColor() -> UIColor {
//        return UIColor(red: 0.25, green: 0.2, blue: 0.2, alpha: 1.0)
        return WSColourScheme.sharedInstance.getColour(colour: WSCSColourOne)
    }
    
    static func darkAppColor() -> UIColor {
        return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
//        return WSColourScheme.sharedInstance.getColour(colour: WSCSColourOne)
    }
    
    static func secondaryTextColor() -> UIColor {
        return WSColourScheme.sharedInstance.getColour(colour: WSCSColourTwo)
    }
    
    static func buttonBackgroundColor() -> UIColor {
        return  WSColourScheme.sharedInstance.getColour(colour: WSCSColourOne)
    }
    
    static func footerTextColor() -> UIColor {
        return UIColor.init(white: 0.96, alpha: 1)
    }
    
    static func footerFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    static func footerBackgroundColor() -> UIColor {
        return self.basicAppColor()
    }
    
    static func highlightedTextColor() -> UIColor {
        return UIColor(red: 1, green: 1, blue: 0, alpha: 0.2)
    }
    
    static func cellColor(even:Bool) -> UIColor {
        return UIColor.init(white: even ? 0.96 : 1.0, alpha: 1)
    }
    
    static func setPageIndicatorColor() {
//        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .black
        appearance.currentPageIndicatorTintColor = .red
        appearance.backgroundColor = UIColor.darkGray
    }
}

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
    
    static func basicAppColor() -> UIColor {
//        return UIColor(red: 0.25, green: 0.2, blue: 0.2, alpha: 1.0)
//        return WSColourScheme.sharedInstance.getColour(colour: WSCSColourOne)
//        0.9019607843137255, 0.49411764705882355, 0.13333333333333333)
//        0.9529411764705882, 0.611764705882353, 0.07058823529411765
//        0.8274509803921568, 0.32941176470588235, 0
//        0.7529411764705882, 0.2235294117647059, 0.168627450
//        0.9058823529411765, 0.2980392156862745, 0.235294117647
//        return UIColor(red: 1, green: 0.39803, blue: 0.3352, alpha: 1)
//        return UIColor(red: 0.90588, green: 0.29803, blue: 0.2352, alpha: 1)
//        return UIColor(red: 0.7529, green: 0.223529, blue: 0.16862, alpha: 1)
//        return UIColor(red: 0.929, green: 0.565, blue: 0.332, alpha: 1)
//        return UIColor(red: 0.901, green: 0.494, blue: 0.133, alpha: 1)
//        return UIColor(red: 0.9529, green: 0.6117, blue: 0.0705, alpha: 1)
        return .white
    }
    
    static func appTintColor() -> UIColor {
        return UIColor(red: 0.7529, green: 0.223529, blue: 0.16862, alpha: 1)
    }
    
    static func topButtonTint() -> UIColor {
        return .black
    }
    
    static func navTitleTextColor() -> UIColor {
        return .black
    }
    
    static func darkAppColor() -> UIColor {
        return UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
//        return WSColourScheme.sharedInstance.getColour(colour: WSCSColourOne)
    }
    
    static func largeTextColor() -> UIColor {
        return .darkGray
    }
    
    static func middleTextColor() -> UIColor {
        return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    static func secondaryTextColor() -> UIColor {
        return WSColourScheme.sharedInstance.getColour(colour: WSCSColourTwo)
    }
    
    static func buttonBackgroundColor() -> UIColor {
        return  WSColourScheme.sharedInstance.getColour(colour: WSCSColourOne)
    }
    
    static func footerTextColor() -> UIColor {
        return UIColor.init(white: 0.16, alpha: 1)
    }
    
    static func footerFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    static func footerBackgroundColor() -> UIColor {
        return UIColor.init(white: 0.85, alpha: 1)
    }
    
    static func highlightedTextColor() -> UIColor {
        return UIColor(red: 1, green: 1, blue: 0, alpha: 0.2)
    }
    
    static func cellColor(even:Bool) -> UIColor {
        return UIColor.init(white: even ? 0.96 : 1.0, alpha: 1)
    }
    
    static func setPageIndicatorColor() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = appTintColor()
        appearance.backgroundColor = basicAppColor()
    }
}

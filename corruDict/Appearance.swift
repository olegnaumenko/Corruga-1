//
//  Appearance.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/11/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

class Appearance
{
    
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
}

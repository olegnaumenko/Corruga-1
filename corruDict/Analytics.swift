//
//  Analytics.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/12/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class Analytics {
    
    static var shared = Analytics()
    private init() {}
    
    func logEvent(name:String, params:[AnyHashable:Any]?) {
        FBSDKAppEvents.logEvent(name, parameters: params)
    }
    
}

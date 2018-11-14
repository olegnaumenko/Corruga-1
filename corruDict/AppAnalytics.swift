//
//  Analytics.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/12/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FirebaseAnalytics

class AppAnalytics {
    
    static var shared = AppAnalytics()
    private init() {}
    
    func logEvent(name:String, params:[String:Any]?) {
        FBSDKAppEvents.logEvent(name, parameters: params)
        Analytics.logEvent(name, parameters: params)
    }
}

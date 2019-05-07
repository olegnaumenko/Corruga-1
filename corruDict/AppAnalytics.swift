//
//  Analytics.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/12/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
//import FBSDKCoreKit
import FirebaseAnalytics

class AppAnalytics {
    
    static var shared = AppAnalytics()
    private init() {}
    
    func logEvent(name:String, params:[String:Any]?) {
//        if let params = params {
//            AppEvents.logEvent(AppEvents.Name(rawValue: name), parameters: params)
//        } else {
//            AppEvents.logEvent(AppEvents.Name(rawValue: name))
//        }
        Analytics.logEvent(name, parameters: params)
    }
}

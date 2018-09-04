//
//  UserActivityFabric.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import Intents
import CoreSpotlight
import CoreServices

class UserActivityFabric
{
    class func create(view:UIView, title:String, id:String, lang:String) {
        
        let activity = NSUserActivity(activityType: "com.naumenko.corruga.translate")

        activity.title = title

        activity.isEligibleForSearch = true
        
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(id + "_" + lang)
        }
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        let keys = title.replacingOccurrences(of: "-", with: " ").replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        attributes.title = title
        attributes.keywords = keys
        attributes.identifier = id
        
        activity.contentAttributeSet = attributes
        
        view.userActivity = activity
        activity.becomeCurrent()
    }
}

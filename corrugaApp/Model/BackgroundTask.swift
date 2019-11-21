//
//  BackgroundTask.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/21/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

class BackgroundTask {
    
    private let name:String
    
    init(name:String) {
        self.name = name
    }
    
    deinit {
        if self.backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
        }
    }
    
    private var backgroundTask:UIBackgroundTaskIdentifier = .invalid
    var inProgress = false {
        didSet {
            if self.inProgress == true && self.backgroundTask == .invalid {
                self.backgroundTask = UIApplication.shared.beginBackgroundTask(withName:name, expirationHandler: nil)
            } else if self.inProgress == false && self.backgroundTask != .invalid {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }
        }
    }
}

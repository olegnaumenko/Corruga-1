//
//  ListViewControllerFinder.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

struct ListViewControllerFinder {
    
    var navController:UINavigationController
    
    var listViewController:ListViewController {
        get {
            let cnt = navController.viewControllers.count
            if cnt > 0 {
                let vc = navController.viewControllers[0]
                return vc as! ListViewController
            } else {
                fatalError()
            }
        }
    }
}

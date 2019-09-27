//
//  ListViewControllerFinder.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

struct ListViewControllerFinder {
    
    var navController:UINavigationController
    
    var listViewController:DictionaryViewController {
        get {
            let cnt = navController.viewControllers.count
            if cnt > 0 {
                let vc = navController.viewControllers[0]
                return vc as! DictionaryViewController
            } else {
                fatalError()
            }
        }
    }
}

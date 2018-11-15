//
//  BaseFeatureCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class BaseFeatureCoordinator: NSObject {

    var basicViewController:BaseFeatureViewController?
    
    func start(viewController:BaseFeatureViewController) {
        viewController.delegate = self
        self.basicViewController = viewController
    }
}

extension BaseFeatureCoordinator : BaseFeatureViewControllerDelegate {
    func baseFeatureWantsShareScreen() {
        
        let shareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        
        let navController = UINavigationController(rootViewController: shareViewController)
        navController.navigationBar.barTintColor = Appearance.basicAppColor()
        navController.navigationBar.tintColor = UIColor.white
        if var titleAttribs = navController.navigationBar.titleTextAttributes {
            titleAttribs[NSForegroundColorAttributeName] = UIColor.white
            navController.navigationBar.titleTextAttributes = titleAttribs
        } else {
            navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        }
        
        self.basicViewController?.present(navController, animated: true, completion: nil)
        
    }
}


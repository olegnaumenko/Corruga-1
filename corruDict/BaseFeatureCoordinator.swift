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
        let navigationBar = navController.navigationBar
        navigationBar.barTintColor = Appearance.basicAppColor()
        navigationBar.tintColor = UIColor.white
        let key = NSAttributedString.Key.foregroundColor
        let color = Appearance.appTintColor()
        if var titleAttribs = navigationBar.titleTextAttributes {
            titleAttribs[key] = color
            navigationBar.titleTextAttributes = titleAttribs
        } else {
            navigationBar.titleTextAttributes = [key:color]
        }
        navController.modalPresentationStyle = .formSheet
        self.basicViewController?.present(navController, animated: true, completion: nil)
    }
}



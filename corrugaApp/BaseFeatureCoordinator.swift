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
        
        let shareViewController = UIStoryboard.shareViewController()
//        let navController = UINavigationController(rootViewController: shareViewController)
//        let navigationBar = navController.navigationBar
//        navigationBar.barTintColor = Appearance.backgroundAppColor()
//        navigationBar.tintColor = Appearance.darkAppColor()
//        let key = NSAttributedString.Key.foregroundColor
//        let color = Appearance.appTintLargeColor()
//        if var titleAttribs = navigationBar.titleTextAttributes {
//            titleAttribs[key] = color
//            navigationBar.titleTextAttributes = titleAttribs
//        } else {
//            navigationBar.titleTextAttributes = [key:color]
//        }
//        if #available(iOS 11.0, *) {
//            navigationBar.prefersLargeTitles = true
//            if var largeTitleAttribs = navigationBar.largeTitleTextAttributes {
//                largeTitleAttribs[key] = color
//                navigationBar.largeTitleTextAttributes = largeTitleAttribs
//            } else {
//                navigationBar.largeTitleTextAttributes = [key:color]
//            }
//        }
        shareViewController.onDismiss = {
            UIView.animate(withDuration: 0.1) {
                UIApplication.shared.keyWindow?.backgroundColor = Appearance.backgroundAppColor()
            }
        }
        shareViewController.onAppear = {
            UIView.animate(withDuration: 0.1) {
                UIApplication.shared.keyWindow?.backgroundColor = UIColor.black
            }
        }
        shareViewController.definesPresentationContext = true
        shareViewController.modalPresentationStyle = .pageSheet
//        shareViewController.modalPresentationCapturesStatusBarAppearance = true
        self.basicViewController?.present(shareViewController, animated: true, completion: nil)
    }
}



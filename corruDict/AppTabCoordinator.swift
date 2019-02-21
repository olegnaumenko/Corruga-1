//
//  AppTabCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

class AppTabCoordinator:NSObject {
    
    let tabBarController:AppTabBarController
    var dictionaryCoordinator:DictionaryCoordinator?
    var newsCoordinator:NewsCoordinator?
    var videosCoordinator:VideosCoordinator?
    var classifiedsCoordinator:ClassifiedsCoordinator?
    
    let videoSource = VideoSource.shared
    
    init(tabBarController:AppTabBarController) {
        
        self.tabBarController = tabBarController
        tabBarController.tabBar.barTintColor = Appearance.basicAppColor()
        if #available(iOS 10.0, *) {
            tabBarController.tabBar.unselectedItemTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        tabBarController.tabBar.tintColor = UIColor(red: 1, green: 1, blue: 0.5, alpha: 1)//(white: 0.8, alpha: 1)
        super.init()
        self.tabBarController.delegate = self;
        
        
        //TODO: minimize this and tab bar controller delegate method:
        
        if let firstNavVC = tabBarController.viewControllers?.first as? UINavigationController,
            let firstVC = firstNavVC.viewControllers.first {
            
            if (firstVC.isKind(of: DictionaryNavViewController.self)) {
                self.dictionaryCoordinator = DictionaryCoordinator(navController:firstNavVC)
            } else if (firstVC.isKind(of: NewsViewController.self)) {
                self.newsCoordinator = NewsCoordinator(newsViewController: firstVC as! NewsViewController)
            } else if (firstVC.isKind(of: VideosViewController.self)) {
                self.videosCoordinator = VideosCoordinator(videosViewController: firstVC as! VideosViewController)
            } else if (firstVC.isKind(of: ClassifiedsViewController.self)) {
                self.classifiedsCoordinator = ClassifiedsCoordinator(newsViewController: firstVC as! ClassifiedsViewController)
            }
            self.decorateNavbarIn(navcontroller: firstNavVC)
        }
    }
    
    fileprivate func decorateNavbarIn(navcontroller:UINavigationController) {
        navcontroller.navigationBar.barTintColor = Appearance.basicAppColor()
        if var titleAttribs = navcontroller.navigationBar.titleTextAttributes {
            titleAttribs[NSForegroundColorAttributeName] = UIColor.white
            navcontroller.navigationBar.titleTextAttributes = titleAttribs
        } else {
            navcontroller.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        }
    }
}

extension AppTabCoordinator:UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //TODO: minimize this and init method:
        
        var eventName = ""
        
        if let navVC = viewController as? UINavigationController,
            let rootViewController = navVC.viewControllers.first {
            if let newsVC = rootViewController as? NewsViewController, self.newsCoordinator == nil {
                self.newsCoordinator = NewsCoordinator(newsViewController: newsVC)
                eventName = "open_news"
            } else if let newVC = rootViewController as? VideosViewController, self.videosCoordinator == nil {
                self.videosCoordinator = VideosCoordinator(videosViewController: newVC)
                eventName = "open_video"
            } else if let dictVC = rootViewController as? ListViewController, self.dictionaryCoordinator == nil {
                self.dictionaryCoordinator = DictionaryCoordinator(navController: dictVC.navigationController!)
                eventName = "open_dict"
            } else if let classVC = rootViewController as? ClassifiedsViewController, self.classifiedsCoordinator == nil {
                self.classifiedsCoordinator = ClassifiedsCoordinator(newsViewController: classVC)
                eventName = "open_board"
            }
            if (eventName.count > 0) {
                AppAnalytics.shared.logEvent(name: eventName, params: nil)
            }
            self.decorateNavbarIn(navcontroller: navVC)
        }
    }
}

extension AppTabCoordinator
{
    
    // MARK: App lifecycle
    
    func appDidFinishLaunching(_ application: UIApplication) {
        videoSource.requestListUpdate()
    }
    
    func appWillResignActive(_ application: UIApplication) {
    }
    
    func appDidEnterBackground(_ application: UIApplication) {
    }
    
    func appWillEnterForeground(_ application: UIApplication) {
        videoSource.requestListUpdate()
    }
}

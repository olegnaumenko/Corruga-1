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
    
    init(tabBarController:AppTabBarController) {
        
        self.tabBarController = tabBarController
        tabBarController.tabBar.barTintColor = Appearance.basicAppColor()
        tabBarController.tabBar.unselectedItemTintColor = UIColor.white
        tabBarController.tabBar.tintColor = UIColor.orange
        super.init()
        self.tabBarController.delegate = self;
        if let firstVC = tabBarController.viewControllers?.first as? UINavigationController {
            self.dictionaryCoordinator = DictionaryCoordinator(navController:firstVC)
        }
    }
}

extension AppTabCoordinator:UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let navVC = viewController as? UINavigationController,
            let rootViewController = navVC.viewControllers.first {
            
            navVC.navigationBar.barTintColor = Appearance.basicAppColor()
            if let newsVC = rootViewController as? NewsViewController {
                self.newsCoordinator = NewsCoordinator(newsViewController: newsVC)
            } else if let newVC = rootViewController as? VideosViewController {
                self.videosCoordinator = VideosCoordinator(videosViewController: newVC)
            }
        }
    }
}

extension AppTabCoordinator
{
    
    // MARK: App lifecycle
    
    func appDidFinishLaunching(_ application: UIApplication) {
    }
    
    func appWillResignActive(_ application: UIApplication) {
    }
    
    func appDidEnterBackground(_ application: UIApplication) {
    }
    
    func appWillEnterForeground(_ application: UIApplication) {
    }
}

//
//  AppTabCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit
//import FTLinearActivityIndicator

class AppTabCoordinator:NSObject {
    
    let tabBarController:AppTabBarController
    var dictionaryCoordinator:DictionaryCoordinator?
    var newsCoordinator:NewsCoordinator?
    var videosCoordinator:VideosCoordinator?
    var boardCoordinator:BoardCoordinator?
    
//    let tabsDescriptiors = [NewsCoordinator.self, VideosCoordinator.self, DictionaryCoordinator.self, BoardCoordinator.self]
    
//    func coordinatorClass(forTabIndex:Int) -> AnyClass {
//        return tabsDescriptiors[forTabIndex]
//    }
    
    init(tabBarController:AppTabBarController) {
        
        Appearance.setPageIndicatorColor()
        
        self.tabBarController = tabBarController
        tabBarController.tabBar.barTintColor = Appearance.backgroundAppColor()
        tabBarController.tabBar.unselectedItemTintColor = Appearance.appTintColor()
        tabBarController.tabBar.tintColor = Appearance.labelSecondaryColor()
        super.init()
        tabBarController.delegate = self;
        
        if let firstNavVC = tabBarController.viewControllers!.first as? UINavigationController,
            let newsVC = firstNavVC.viewControllers.first as? NewsViewController {
            self.newsCoordinator = NewsCoordinator(newsViewController: newsVC)
            self.decorateNavbarIn(navcontroller: firstNavVC)
        }
    }
    
    
    fileprivate func decorateNavbarIn(navcontroller:UINavigationController) {
        navcontroller.navigationBar.barTintColor = Appearance.backgroundAppColor()
        let navigationBar = navcontroller.navigationBar
        let key = NSAttributedString.Key.foregroundColor
        let color = Appearance.appTintColor()
        if var titleAttribs = navigationBar.titleTextAttributes {
            titleAttribs[key] = color
            navigationBar.titleTextAttributes = titleAttribs
        } else {
            navigationBar.titleTextAttributes = [key:color]
        }
        
        if #available(iOS 11.0, *) {
            if var largeTitleAttribs = navigationBar.largeTitleTextAttributes {
                largeTitleAttribs[key] = color
                navigationBar.largeTitleTextAttributes = largeTitleAttribs
            } else {
                navigationBar.largeTitleTextAttributes = [key:color]
            }
        }
    }
}

extension AppTabCoordinator:UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //TODO: minimize this and init method:
        
        var eventName = ""
        
        if let navVC = viewController as? UINavigationController,
            let index = tabBarController.viewControllers?.firstIndex(of: navVC),
            let rootViewController = navVC.viewControllers.first {
            if let newsVC = rootViewController as? NewsViewController, self.newsCoordinator == nil {
                self.newsCoordinator = NewsCoordinator(newsViewController: newsVC)
                eventName = "open_news"
            } else if let newVC = rootViewController as? VideosViewController, self.videosCoordinator == nil {
                self.videosCoordinator = VideosCoordinator(videosViewController: newVC)
                eventName = "open_video"
            } else if let dictVC = rootViewController as? DictionaryViewController, self.dictionaryCoordinator == nil {
                self.dictionaryCoordinator = DictionaryCoordinator(navController: dictVC.navigationController!)
                eventName = "open_dict"
            } else if let classVC = rootViewController as? NewsViewController, index == 3, self.boardCoordinator == nil {
                self.boardCoordinator = BoardCoordinator(newsViewController: classVC)
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
        
        //doesn't work well, creates one more window without root vc:
//        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
        
        DictModel.shared.setup()
        VideoSource.shared.reload()
    }
    
    func appWillResignActive(_ application: UIApplication) {
    }
    
    func appDidEnterBackground(_ application: UIApplication) {
    }
    
    func appWillEnterForeground(_ application: UIApplication) {

    }
    
    func appDidBecomeActive() {
        
    }
    
    func appWillTerminate() {
        
    }
}


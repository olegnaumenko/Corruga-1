//
//  AppDelegate.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import Firebase
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coordinator:AppTabCoordinator!// AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { params, error in
            if error == nil {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
                // ... insert custom logic here ...
                print("params: %@", params as? [String: AnyObject] ?? {})
            }
        })
        
        FirebaseApp.configure()
        
        guard let window = self.window else {
            fatalError()
        }
        
        window.backgroundColor = Appearance.backgroundAppColor()
        let tabBarController = (window.rootViewController as! AppTabBarController)
        self.coordinator = AppTabCoordinator(tabBarController: tabBarController)
        self.coordinator.appDidFinishLaunching(application)
        return true
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        // pass the url to the handle deep link call
//        let branchHandled = Branch.getInstance().application(application,
//                                                             open: url,
//                                                             sourceApplication: sourceApplication,
//                                                             annotation: annotation
//        )
//        if (!branchHandled) {
//            // If not handled by Branch, do other deep link routing for the Facebook SDK, Pinterest SDK, etc
//        }
//
//        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
//        return true
//    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = Branch.getInstance()!.application(app,
                                                        open: url,
                                                        options: options)
        return handled
    }
    
//    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//
//    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        Branch.getInstance().continue(userActivity)
        
        if let title = userActivity.title {
            self.coordinator.dictionaryCoordinator?.translate(term: title)
        } else if let title = userActivity.contentAttributeSet?.title {
            self.coordinator.dictionaryCoordinator?.translate(term: title)
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        self.coordinator.appWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.coordinator.appDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        self.coordinator.appWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.coordinator.appDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.coordinator.appWillTerminate()
    }


}


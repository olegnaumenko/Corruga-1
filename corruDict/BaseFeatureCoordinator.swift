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
        if var titleAttribs = convertFromOptionalNSAttributedStringKeyDictionary(navController.navigationBar.titleTextAttributes) {
            titleAttribs[convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor)] = UIColor.white
            navController.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(titleAttribs)
        } else {
            navController.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColor.white])
        }
        navController.modalPresentationStyle = .formSheet
        self.basicViewController?.present(navController, animated: true, completion: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalNSAttributedStringKeyDictionary(_ input: [NSAttributedString.Key: Any]?) -> [String: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

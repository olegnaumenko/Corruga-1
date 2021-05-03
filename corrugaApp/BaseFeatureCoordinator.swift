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
    
    func presentShareViewController() {
        let shareViewController = UIStoryboard.shareViewController()
        self.presentAsAPage(vc: shareViewController)
    }
    
    func presentAsAPage(vc:PresentationReportingViewController) {
        vc.onDismiss = {
            UIView.animate(withDuration: 0.1) {
                UIApplication.shared.keyWindow?.backgroundColor = Appearance.backgroundAppColor()
            }
        }
        vc.onAppear = {
            UIView.animate(withDuration: 0.1) {
                UIApplication.shared.keyWindow?.backgroundColor = UIColor.black
            }
        }
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .pageSheet
        self.basicViewController?.present(vc, animated: true, completion: nil)
    }
}



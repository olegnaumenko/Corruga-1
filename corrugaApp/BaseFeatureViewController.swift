//
//  BaseFeatureViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

extension UIViewController {
    func showShareActivity(_ sender:Any, items:[Any], title:String?, completion:@escaping (_ completed:Bool, _ activityType:UIActivity.ActivityType?)->())
    {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.title = title
        
        if let barButton = sender as? UIBarButtonItem {
            activityController.popoverPresentationController?.barButtonItem = barButton
        } else if let sourceView = sender as? UIView {
            activityController.popoverPresentationController?.sourceView = sourceView
            activityController.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        
//        activityController.popoverPresentationController?.backgroundColor = UIColor.lightGray
        
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            completion(completed, activityType)
        }
        self.present(activityController, animated: true, completion: nil)
    }
}

protocol BaseFeatureViewControllerDelegate:class {
    func presentAsAPage(vc:PresentationReportingViewController)
    func presentShareViewController()
}

protocol ReachabilityAwareViewController {
    func setReachabilityIndicator(visible:Bool)
}

class BaseFeatureViewController: UIViewController, ReachabilityAwareViewController {

    weak var delegate:BaseFeatureViewControllerDelegate?
    
    lazy var connectionIndicatorController = ReachabilityIndicatorController(parentViewController: self)
    
    @IBAction func onQRButton(_ sender:UIBarButtonItem) {
        self.delegate?.presentShareViewController()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    internal func setReachabilityIndicator(visible:Bool) {
        self.connectionIndicatorController.set(visibility: visible)
    }
}

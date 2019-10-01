//
//  BaseFeatureViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

protocol BaseFeatureViewControllerDelegate:class {
    func baseFeatureWantsShareScreen()
}

protocol ReachabilityAwareViewController {
    func setReachabilityIndicator(visible:Bool)
}

class BaseFeatureViewController: UIViewController, ReachabilityAwareViewController {

    weak var delegate:BaseFeatureViewControllerDelegate?
    
    lazy var connectionIndicatorController = ConnectionIndicatorController(parentViewController: self)
    
    @IBAction func onQRButton(_ sender:UIBarButtonItem) {
        self.delegate?.baseFeatureWantsShareScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.tintColor = Appearance.darkAppColor()
    }
    
    internal func setReachabilityIndicator(visible:Bool) {
        self.connectionIndicatorController.set(visibility: visible)
    }
}

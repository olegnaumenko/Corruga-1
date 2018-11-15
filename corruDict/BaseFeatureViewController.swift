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


class BaseFeatureViewController: UIViewController {

    weak var delegate:BaseFeatureViewControllerDelegate?
    
    @IBAction func onQRButton(_ sender:UIBarButtonItem) {
        self.delegate?.baseFeatureWantsShareScreen()
    }

}

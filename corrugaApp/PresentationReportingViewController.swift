//
//  PresentationReportingViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 03.05.2021.
//  Copyright © 2021 oleg.naumenko. All rights reserved.
//

import UIKit

class PresentationReportingViewController: UIViewController {
    
    var onDismiss = {}
    var onAppear = {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onDismiss()
    }

}

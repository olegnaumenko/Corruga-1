//
//  ClassifiedsCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 10/5/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class ClassifiedsCoordinator: BaseFeatureCoordinator {
    
    let boardUrlString = "https://market.gofro.expert"//"http://bazar.gofro.expert/"
    
    let newsViewController:ClassifiedsViewController
    
    init(newsViewController:ClassifiedsViewController) {
        self.newsViewController = newsViewController
        self.newsViewController.urlString = boardUrlString
        super.init()
        self.start(viewController: newsViewController)
    }
}

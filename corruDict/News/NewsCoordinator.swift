//
//  NewsCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class NewsCoordinator: BaseFeatureCoordinator {
    
    let newsViewController:NewsViewController
    init(newsViewController:NewsViewController) {
        self.newsViewController = newsViewController
        self.newsViewController.urlString = "http://novosti.gofro.expert/novosti/"
        super.init()
        self.start(viewController: newsViewController)
    }
}


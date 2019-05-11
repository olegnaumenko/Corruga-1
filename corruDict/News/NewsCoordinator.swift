//
//  NewsCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class NewsCoordinator: BaseFeatureCoordinator {
    
//    let newsURLString = "https://novosti.gofro.expert/novosti/"
    let newsURLString = "https://novosti.gofro.expert/wp-json/wp/v2/posts"
    let newsViewController:NewsViewController
    
    init(newsViewController:NewsViewController) {
        self.newsViewController = newsViewController
        self.newsViewController.urlString = newsURLString
        super.init()
        self.start(viewController: newsViewController)
    }
}


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
        super.init()
        self.newsViewController.navigationDelegate = self
        self.start(viewController: newsViewController)
    }
}

extension NewsCoordinator:NewsViewControllerDelegate {
    func newsViewControllerDidSelect(item : NewsItem) {
        let itemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsItemViewController") as! NewsItemViewController
        itemViewController.urlString = item.url
        itemViewController.title = item.title
        self.newsViewController.navigationController?.pushViewController(itemViewController, animated: true)
    }
}


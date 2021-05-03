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
    let source = NewsSource(itemType: .news)
    
    init(newsViewController:NewsViewController) {
        self.newsViewController = newsViewController
        super.init()
        self.newsViewController.viewModel = NewsViewModel(itemSource: source)
        self.newsViewController.viewModel.navigationDelegate = self
        self.start(viewController: newsViewController)
    }
}

extension NewsCoordinator:NewsViewControllerDelegate {
    func newsViewControllerDidSelect(item:NewsItem) -> Bool {
        
        let itemViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WebItemViewController") as! WebItemViewController
        itemViewController.viewModel = WebItemViewModel(item: item, source: source)
//        self.presentAsAPage(vc: itemViewController)
        self.newsViewController.navigationController?.pushViewController(itemViewController, animated: true)
        return true
    }
}


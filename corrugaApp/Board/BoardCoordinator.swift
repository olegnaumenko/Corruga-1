//
//  ClassifiedsCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 10/5/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class BoardCoordinator: BaseFeatureCoordinator {
    
    let newsViewController:NewsViewController
    let source = NewsSource(itemType: .board)
    
    init(newsViewController:NewsViewController) {
        self.newsViewController = newsViewController
        super.init()
        self.newsViewController.viewModel = NewsViewModel(itemSource: source)
        self.newsViewController.viewModel.navigationDelegate = self
        self.start(viewController: newsViewController)
    }
    
    func createWebViewController(item:NewsItem) -> UIViewController {
        let itemViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WebItemViewController") as! WebItemViewController
        itemViewController.viewModel = WebItemViewModel(item: item, source: source)
        return itemViewController
    }
}

extension BoardCoordinator: NewsViewControllerDelegate {
    func newsViewControllerDidPick(item: NewsItem) -> UIViewController? {
        return createWebViewController(item: item)
    }
    
    func newsViewControllerDidSelect(item:NewsItem) -> Bool {
        
        let webItemViewController = createWebViewController(item: item)
        self.newsViewController.navigationController?.pushViewController(webItemViewController, animated: true)
        return true
    }
}

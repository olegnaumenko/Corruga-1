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
}

extension BoardCoordinator: NewsViewControllerDelegate {
    func newsViewControllerDidSelect(item:NewsItem) -> Bool {
        
        let itemViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "NewsItemViewController") as! WebItemViewController
        itemViewController.viewModel = WebItemViewModel(item: item, source: source)
        self.newsViewController.navigationController?.pushViewController(itemViewController, animated: true)
        return true
    }
}

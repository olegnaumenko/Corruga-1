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
        self.newsViewController.viewModel = NewsViewModel(itemSource: NewsSource(itemType: .news))
        self.newsViewController.viewModel.navigationDelegate = self
        self.start(viewController: newsViewController)
    }
}

extension NewsCoordinator:NewsViewControllerDelegate {
    func newsViewControllerDidSelect(post : NewsOpenPost) -> Bool {
        
        let itemViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "NewsItemViewController") as! WebItemViewController
        itemViewController.urlString = post.htmlURL
//        itemViewController.title = post.title
        itemViewController.content = post.content
        self.newsViewController.navigationController?.pushViewController(itemViewController, animated: true)
        return true
    }
}


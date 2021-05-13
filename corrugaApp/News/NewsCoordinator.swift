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
    
    private func webItemPreviewActions(_ webItemViewModel:WebItemViewModel) -> [UIPreviewAction] {
        let shareAction = UIPreviewAction(title: "news-coord-share-post-link".n10, style: .default) { [weak self] (action, controller) in
            guard let self = self else { return }
            let url = webItemViewModel.baseURL.absoluteString
            self.newsViewController.showShareActivity(self.newsViewController, items: [url], title: nil) { (completed, activityType) in
                if (completed) {
                    AppAnalytics.shared.logEvent(name:"share_link_success", params:["activity":activityType ?? "nil"])
                } else {
                    AppAnalytics.shared.logEvent(name:"share_link_decline", params:nil)
                }
            }
        }
        
        let openAction = UIPreviewAction(title: "news-coord-open-on-website".n10, style: .default) { (action, controller) in
            let url = webItemViewModel.baseURL
            let opts = [UIApplication.OpenExternalURLOptionsKey : Any]()
            UIApplication.shared.open(url, options: opts, completionHandler: nil)
        }
        return [shareAction, openAction]
    }
    
    private func createWebViewController(item:NewsItem) -> UIViewController {
        let itemViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WebItemViewController") as! WebItemViewController
        itemViewController.viewModel = WebItemViewModel(item: item, source: source)
        itemViewController.previewActions = webItemPreviewActions(itemViewController.viewModel)
        return itemViewController
    }
}

extension NewsCoordinator:NewsViewControllerDelegate {
    
   
    func newsViewControllerDidPick(item: NewsItem) -> UIViewController? {
        let webItemViewController = createWebViewController(item: item)
        return webItemViewController
    }
    
    func newsViewControllerDidSelect(item:NewsItem) -> Bool {
        let webItemViewController = createWebViewController(item: item)
        self.newsViewController.navigationController?.pushViewController(webItemViewController, animated: true)
        return true
    }
}


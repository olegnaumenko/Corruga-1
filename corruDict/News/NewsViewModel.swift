//
//  NewsViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/13/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

class NewsViewModel {

    
    var onRefreshNeeded = {}
    
    var searchTerm:String? {
        didSet {
            NewsSource.shared.searchTerm = self.searchTerm
        }
    }
    
    init() {
        NewsSource.shared.onItemsChange = { [weak self] in
            self?.onRefreshNeeded()
        }
    }
    
    var numberOfItems:Int {
        return NewsSource.shared.newsItems.count
    }
    
    func item(atIndex:Int) -> NewsItem {
        return NewsSource.shared.newsItems[atIndex]
    }
    
}

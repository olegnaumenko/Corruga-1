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
    var itemSource:NewsSource
    
    private var searchTerm:String? {
        didSet {
            self.itemSource.searchTerm = self.searchTerm
        }
    }
    
    var title:String {
        return self.itemSource.itemType.title
    }
    
    func setSearch(term:String?) {
        if let count = term?.count, count > 0 {
            self.searchTerm = term
        } else {
            self.searchTerm = nil
            self.onRefreshNeeded()
        }
    }
    
    init(itemSource:NewsSource) {
        self.itemSource = itemSource
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewDidLoad() {
        self.itemSource.reload()
    }
    
    func viewWillAppear() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onItemsUpdate(_:)),
                                               name: .NewsSourceItemsUpdated,
                                               object: nil)
    }
    
    func viewDidDissapear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onItemsUpdate(_ n:Notification) {
        self.onRefreshNeeded()
    }
    
    private func arrayForDisplay() -> [NewsItem] {
        return self.searchTerm == nil ? itemSource.newsItems : itemSource.searchItems
    }
    
    var numberOfItems:Int {
        return arrayForDisplay().count
    }
    
    func item(atIndex:Int) -> NewsItem {
        return arrayForDisplay()[atIndex]
    }
    
}

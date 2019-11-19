//
//  NewsViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/13/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit
import Reachability

class NewsViewModel {

    var onRefreshNeeded = {}
    var onReachabilityChange = {}
    var itemSource:NewsSource
    var isViewVisible = false
    
    private var searchTerm:String? {
        didSet {
            self.itemSource.searchTerm = self.searchTerm
        }
    }
    
    var title:String {
        return self.itemSource.itemType.title
    }
    
    var isNetworkReachable:Bool {
        get {
            return Client.shared.isNetworkReachable()
        }
    }
    
    init(itemSource:NewsSource) {
        self.itemSource = itemSource
    }
    
    deinit {
        self.unSubscribe()
    }
    
    private func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onReachabilityStatus(_:)),
                                               name: .reachabilityChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onItemsUpdate(_:)),
                                               name: .NewsSourceItemsUpdated,
                                               object: nil)
    }
    
    private func unSubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func onViewWillAppear() {
        self.onReachabilityChange()
        self.reloadIfNeeded()
        self.subscribe()
        isViewVisible = true
    }
    
    func onViewDidDissapear() {
        unSubscribe()
        isViewVisible = false
    }
    
    func setSearch(term:String?) {
        if let count = term?.count, count > 0 {
            self.searchTerm = term
        } else {
            self.searchTerm = nil
            self.onRefreshNeeded()
        }
    }

        
// MARK: - Notification handlers
    
    @objc private func onReachabilityStatus(_ n:Notification) {
        self.reloadIfNeeded()
        self.onReachabilityChange()
    }
    
    private func reloadIfNeeded() {
        if self.isNetworkReachable && self.arrayForDisplay().count == 0 {
            self.itemSource.reload()
        }
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

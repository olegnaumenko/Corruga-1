//
//  NewsViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/13/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//


import UIKit
import AFNetworking

class NewsViewModel {

    var onRefreshNeeded = {}
    var onLoadingFinished = {}
    var onReachabilityChange = {}
    var itemSource:NewsSource
    var isViewVisible = false
    
    weak var navigationDelegate:NewsViewControllerDelegate?
    
    private var lastRequestedOffset = -1;
    
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
    
    var isInSearchMode:Bool {
        if let searchTerm = self.searchTerm {
            return searchTerm.count > 0
        }
        return false
    }
    
    private var _loading = false
    
    var showLoadingIndicator:Bool {
        return (arrayForDisplay().count == 0 && _loading == true && isNetworkReachable)
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
                                               name: .AFNetworkingReachabilityDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onItemsUpdate(_:)),
                                               name: .NewsSourceItemsUpdated,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onItemsError(_:)),
                                               name: .NewsSourceItemsLoadingError,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onItemsLoadingFinished(_:)),
                                               name: .NewsSourceItemsLoadingFinished,
                                               object: nil)
    }
    
    private func unSubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func onViewWillAppear() {
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
        }
        _loading = true
        self.onRefreshNeeded()
    }

    func didSelecteItem(index:Int) -> Bool {
        
        let item = arrayForDisplay()[index]
        if item.type == .adsType, let url = URL(string: item.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return false
        }
        return self.navigationDelegate?.newsViewControllerDidSelect(item: item) ?? false        
    }
    
    func viewControllerForPickItem(index:Int) -> UIViewController? {
        return self.navigationDelegate?.newsViewControllerDidPick(item: item(atIndex: index))
    }
    
    func onOverscroll() -> Bool {
        if searchTerm != nil {
            return false
        }
        self.itemSource.getMoreItemsOnOverscroll()
        return true
    }
    
    
// MARK: - Notification handlers
    
    @objc private func onReachabilityStatus(_ n:Notification) {
        self.reloadIfNeeded()
        self.onReachabilityChange()
    }
    
    private func reloadIfNeeded() {
        if self.arrayForDisplay().count == 0 {
            if (searchTerm == nil) {
                self.itemSource.reload()
            } else {
                self.itemSource.reloadSearch()
            }
        } else {
            self.onRefreshNeeded()
        }
        _loading = true
    }

    @objc private func onItemsUpdate(_ n:Notification) {
        self.onRefreshNeeded()
        self.onReachabilityChange()
    }
    
    @objc private func onItemsError(_ n:Notification) {
        _loading = false
        self.onReachabilityChange()
    }
    
    @objc private func onItemsLoadingFinished(_ n:Notification) {
        _loading = false
        self.onLoadingFinished()
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

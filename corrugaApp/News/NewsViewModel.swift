//
//  NewsViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/13/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//


import UIKit
import AFNetworking
import SwiftSoup

class NewsViewModel {

    var onRefreshNeeded = {}
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

    func didSelecteItem(index:Int) -> Bool {
        
        let item = itemSource.newsItems[index]
        
        if item.type == .adsType, let url = URL(string: item.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return false
        }
        
        itemSource.getNewsPost(id: item.id) { (post, error) in
            if let post = post {
                var newPost = NewsOpenPost(id:post.id, title: post.title, content:self.parse(post: post), htmlURL: post.htmlURL)
                _ = self.navigationDelegate?.newsViewControllerDidSelect(post: newPost)
            }
        }
        return true
    }
    
//    font: -apple-system-body
//    font: -apple-system-headline
//    font: -apple-system-subheadline
//    font: -apple-system-caption1
//    font: -apple-system-caption2
//    font: -apple-system-footnote
//    font: -apple-system-short-body
//    font: -apple-system-short-headline
//    font: -apple-system-short-subheadline
//    font: -apple-system-short-caption1
//    font: -apple-system-short-footnote
//    font: -apple-system-tall-body

    
    private func parse(post:NewsOpenPost) -> String {
        let content = post.content
        let doc: Document = try! SwiftSoup.parse(content)
        print("======")

        let styleText = """
            body{font-size:36px;font-family:-apple-system;margin:38px;}
            p{text-align:justify}
            img.alignleft {float:left;margin-right:40px;margin-bottom:16px;margin-top:8px;width:48%;height:auto;}
            img.alignright{float:right;margin-left:40px;margin-bottom:16px;margin-top:8px;width:44%;height:auto;}
            img.aligncenter{float:none;}
            img.size-full,img.size-large {max-width:100%;height:auto;}
            div.fitvids-video{max-width:100%;height:auto;position:relative}
            """

        let head = doc.head()
        try! head?.appendElement("style").appendText(styleText)
        let body = doc.body()
        
        try! body?.prepend("<h2>\(post.title)</h2>")
        
        try! doc.select("p").forEach { (element) in
            
            var pHtml = try! element.html()
            
            pHtml = pHtml.replacingOccurrences(of: "</strong>", with: "");
            pHtml = pHtml.replacingOccurrences(of: "<strong>", with: "");
            pHtml = pHtml.replacingOccurrences(of: "&nbsp;", with: " ");

            try! element.html(pHtml)
            
            print(try! element.html())
            print("======")
        }
        
        let html = try! doc.html()
        print(html)
        print("======")
        return html
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

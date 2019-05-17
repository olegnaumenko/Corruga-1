//
//  NewsSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/16/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

struct NewsItem {
    let id:Int
    let title:String
    let shortText:String
    let date:String
    let views:Int
    let url:String
}

class NewsSource: NSObject {

    static let shared = NewsSource()
    
    var currentPageSize = 10
    var currentPageIndex = 0
    
    var newsItems = [NewsItem]()
    
    var onItemsChange = {}
    
    func refreshNews() {
        currentPageIndex = 0;
        self.newsItems.removeAll()
        self.onItemsChange()
        self.getNextItems()
//        self.getNewsItems(pageIndex: pageIndex, pageItems: pageSize) { [weak self] (newsArray, receivedPageIndex) in
//            if let na = newsArray {
//                guard let the = self else {
//                    return
//                }
//                the.newsItems.append(contentsOf: na)
//                the.onItemsChange()
//
//            } else {
//
//            }
//        }
    }
    
    func getNextItems() {
        self.getNewsItems(pageIndex: currentPageIndex, pageItems: currentPageSize) { [weak self] (newsArray, receivedPageIndex) in
            if let na = newsArray {
                if let self = self {
                    self.newsItems.append(contentsOf: na)
                    self.onItemsChange()
                    self.currentPageIndex = receivedPageIndex + 1
                    if self.currentPageSize < 50 {
                        self.currentPageSize = 50
                    }
                    self.getNextItems()
                }
            } else {
                print("finished loading news, total: \(self?.currentPageIndex ?? 0 + 1) pages")
            }
        }
    }
    
    func getNewsItems(pageIndex:Int, pageItems:Int, completion:@escaping ([NewsItem]?, Int)->()) {
        
        Client.shared.getNewsFeed(pageIndex: pageIndex, itemsInPage: pageItems) { (dataArray, error) in
            if let arrayOfDicts = dataArray {
                var items = [NewsItem]()
                items.reserveCapacity(arrayOfDicts.count)
                
                arrayOfDicts.forEach({ (dict) in
                    if let item = self.newsItem(dict: dict as! [AnyHashable : Any]) {
                        items.append(item)
                    }
                })
                completion(items, pageIndex)
            } else {
                completion(nil, 0)
            }
        }
    }
    
    private func newsItem(dict:[AnyHashable:Any]) -> NewsItem? {
        
        if let title = (dict["title"] as? [AnyHashable:Any])?["rendered"] as? String,
            let excerpt = (dict["excerpt"] as? [AnyHashable:Any])?["rendered"] as? String,
            let date = dict["date_gmt"] as? String,
            let url = dict["link"] as? String,
            let id = dict["id"] as? Int {
            return NewsItem(id:id, title:filterHtml(title), shortText:filterHtml(excerpt), date:filterDate(date), views:0, url:url)
        }
        return nil;
    }
    
    private func filterHtml(_ string:String) -> String {
        
        let regexString = "&[#]?\\w{3,4};|<[/]?[p|b]>|\n"
//        let regexString = "<(b|p|div|span)>"

        if let regex = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length:  string.count), withTemplate: "")
            return modString
        }
        return ""
    }
    
    private func filterDate(_ string:String) -> String {
        return string.replacingOccurrences(of: "T", with: " ")
    }
}

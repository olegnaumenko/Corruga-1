//
//  BoardSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/18/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import Foundation

struct BoardItem {
    let id:Int
    let title:String
    let shortText:String
    let date:String
    let views:Int
    let url:String
}

class BoardSource {
    
    static let shared = BoardSource()
    
    var currentPageSize = 10
    var currentPageIndex = 0
    
    var boardItems = [BoardItem]()
    
    var onItemsChange = {}
    
    func reload() {
        currentPageIndex = 0;
        self.boardItems.removeAll()
        self.onItemsChange()
        self.getNextItems()
    }
    
    func getNextItems() {
        self.getItems(pageIndex: currentPageIndex, pageItems: currentPageSize) { [weak self] (newsArray, receivedPageIndex) in
            if let na = newsArray {
                if let self = self {
                    self.boardItems.append(contentsOf: na)
                    self.onItemsChange()
                    self.currentPageIndex = receivedPageIndex + 1
                    if self.currentPageSize < 50 {
                        self.currentPageSize = 50
                    }
                    self.getNextItems()
                }
            } else {
                print("finished loading board, total: \(self?.currentPageIndex ?? 0 + 1) pages")
            }
        }
    }
    
    func getItems(pageIndex:Int, pageItems:Int, completion:@escaping ([BoardItem]?, Int)->()) {
        
        Client.shared.getNewsFeed(pageIndex: pageIndex, itemsInPage: pageItems) { (dataArray, error) in
            if let arrayOfDicts = dataArray {
                var items = [BoardItem]()
                items.reserveCapacity(arrayOfDicts.count)
                
                arrayOfDicts.forEach({ (dict) in
                    if let item = self.boardItem(dict: dict as! [AnyHashable : Any]) {
                        items.append(item)
                    }
                })
                completion(items, pageIndex)
            } else {
                completion(nil, 0)
            }
        }
    }
    
    private func boardItem(dict:[AnyHashable:Any]) -> BoardItem? {
        
        if let title = (dict["title"] as? [AnyHashable:Any])?["rendered"] as? String,
            let excerpt = (dict["excerpt"] as? [AnyHashable:Any])?["rendered"] as? String,
            let date = dict["date_gmt"] as? String,
            let url = dict["link"] as? String,
            let id = dict["id"] as? Int {
            return BoardItem(id:id, title:filterHtml(title), shortText:filterHtml(excerpt), date:filterDate(date), views:0, url:url)
        }
        return nil;
    }
    
    private func filterHtml(_ string:String) -> String {
        
        let regexString = "&[#]?\\w{3,4};|<[/]?[p|b]>|\n"
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

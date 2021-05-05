//
//  NewsSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/16/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

enum SourceCategory:Int {
    case news
    case board
}

extension SourceCategory {
    var title:String {
        switch self {
        case .board:
            return "tab-bar-board-title"
        default:
            return "tab-bar-news-title"
        }
    }
}

enum NewsItemType {
    case newsType
    case adsType
}

protocol TypedItem {
    var type:NewsItemType { get }
}

struct NewsItem:TypedItem {
    let id:Int
    let title:String
    let shortText:String
    let date:String
    let views:Int
    let url:String
    var imageURL:String?
    var adImage:String?
    var type: NewsItemType
}

struct NewsOpenPost {
    let id:Int
    let title:String
    let content:String
    let htmlURL:String
    let date:String
}

extension NSNotification.Name {
    public static let NewsSourceItemsStartedLoading = NSNotification.Name("NewsSourceStartedLoading")
    public static let NewsSourceItemsUpdated = NSNotification.Name("NewsSourceItemsUpdated")
    public static let NewsSourceItemsLoadingError = NSNotification.Name("NewsSourceItemsLoadingError")
    public static let NewsSourceItemsLoadingFinished = NSNotification.Name("NewsSourceItemsLoadingFinished")
}

class NewsSource: NSObject {

   private let kPartnerImagesDIR = "images/partners"
    private let kImagesEXTPNG = "png"
    let adImageCountryMap = [
        "1"  : "ad-pic-title-1",
        "2"  : "ad-pic-title-2",
        "3"  : "ad-pic-title-3",
        "4"  : "ad-pic-title-4",
        "5"  : "ad-pic-title-5",
        "6"  : "ad-pic-title-6",
        "7"  : "ad-pic-title-7",
        "8"  : "ad-pic-title-8",
        "9"  : "ad-pic-title-9",
        "10" : "ad-pic-title-10",
        "11" : "ad-pic-title-11"
    ]
    
    lazy var adImages = Bundle.main.paths(forResourcesOfType: self.kImagesEXTPNG, inDirectory: self.kPartnerImagesDIR)
    
    let itemType:SourceCategory
    
    var currentPageSize = 16
    var currentOffset = 0
    
    var currentSearchOffset = 0
    
    var currentAdImageIndex = 0
    
    var newsItems = [NewsItem]()
    var searchItems = [NewsItem]()
    
    private var lastDateCheckTime = CFAbsoluteTime(0)
    
    private var loadInProgress = false {
        didSet {
            let currentTime = CFAbsoluteTimeGetCurrent()
            if newsItems.count != 0 && loadInProgress == false && currentTime - lastDateCheckTime > 60 {
                for item in newsItems {
                    if item.date.isEmpty == false {
                        Settings.s.newsLastUpdateDate = item.date
                        lastDateCheckTime = currentTime
                        break
                    }
                }
            }
        }
    }
    
    private var searchTasksCount = 0
    
    var searchTerm:String? {
        didSet {
            if let searchTerm = self.searchTerm, searchTerm.count > 0 {
                reloadSearch()
            } 
        }
    }
    
    init(itemType:SourceCategory) {
        self.itemType = itemType
        super.init()
        self.currentAdImageIndex = Int(arc4random_uniform(UInt32(adImages.count)))
    }
    
    private func onItemsChange() {
        NotificationCenter.default.post(name: .NewsSourceItemsUpdated, object: nil, userInfo: ["total-items" : newsItems.count])
    }
    
    private func onLoadingError() {
        NotificationCenter.default.post(name: .NewsSourceItemsLoadingError, object: nil)
    }
    
    private func onSearchItemsChange() {
        NotificationCenter.default.post(name: .NewsSourceItemsUpdated, object: nil, userInfo: ["total-search-items" : searchItems.count])
    }
    
    private func onItemsLoadFinished() {
        NotificationCenter.default.post(name: .NewsSourceItemsLoadingFinished, object: nil, userInfo: ["total-items" : newsItems.count])
    }
    
    private func onSearchItemsLoadFinished() {
        NotificationCenter.default.post(name: .NewsSourceItemsLoadingFinished, object: nil, userInfo: ["total-search-items" : searchItems.count])
    }
    
    func reload() {
        if loadInProgress == true {
            return
        }
        currentOffset = 0;
        newsItems.removeAll()
        onItemsChange()
        loadInProgress = true
        
        getNextItems(offset:currentOffset, count: currentPageSize, recursively: false)
    }
    
    func reloadSearch() {
        currentSearchOffset = 0;
        currentPageSize = 10;
        searchItems.removeAll()
        onSearchItemsChange()
        getNextSearchItems()
    }
    
    
    private func appendItems(items:[NewsItem], offset:Int) {
        if (offset >= self.newsItems.count) {
            self.newsItems.append(contentsOf: items)
        } else {
            self.newsItems.replaceSubrange(offset..<self.newsItems.count, with: items)
        }
    }
    
    func fetchRecentPostsCount(completion:@escaping (Int, Error?)->()) {
        if let latestPostDateString = Settings.s.newsLastUpdateDate {
            Client.shared.fetchFeedAfter(type: .news, dateString: latestPostDateString) { (itemsArray, total, error) in
                if error != nil {
                    completion(0, error)
                } else if let items = itemsArray {
                    completion(items.count, nil)
//                    if let dict = items.first as? [String:Any], let date = dict["date"] as? String {
//                        Settings.s.newsLastUpdateDate = date
//                    }
                }
            }
        }
    }
    
    func getNextItems(offset:Int = 0, count:Int = 45, recursively:Bool = false) {
        
        self.getNewsItems(offset: self.newsItems.count, count: count, search: nil) { [weak self] (newsArray, receivedOffset, totalItems, searchString) in
            if let self = self {
                if let na = newsArray {
                    
                    print("got items: ", receivedOffset, self.currentOffset, na.count, totalItems)
                    
                    self.appendItems(items: na, offset: receivedOffset)
                    self.onItemsChange()
                    self.currentOffset = receivedOffset + na.count
                    
                    if self.currentPageSize < 45 {
                        self.currentPageSize = 45
                    }
                    if na.count != 0 && recursively == true {
                        self.getNextItems(offset:self.currentOffset, count:self.currentPageSize, recursively: recursively)
                    } else {
                        self.loadInProgress = false
                        print("finished loading items, total: \(self.newsItems.count) items")
                    }
                } else {
                    self.loadInProgress = false
                    self.onLoadingError()
                    print("finished loading items, total: \(self.newsItems.count) items")
                }
            }
        }
    }
    
    func getMoreItemsOnOverscroll() {
        if (loadInProgress) {
            return
        }
        loadInProgress = true
        getNextItems(offset: newsItems.count, count: 45, recursively: false)
    }
    
    func getNextSearchItems() {
        searchTasksCount += 1
        self.getNewsItems(offset: currentSearchOffset, count: 45, search: searchTerm) { [weak self] (newsArray, receivedOffset, totalItems, searchString) in
            if let self = self {
                if let na = newsArray, let ss = searchString, self.searchTerm == ss {
                    
                    self.searchItems.append(contentsOf: na)
                    self.onSearchItemsChange()
                    
                    self.currentSearchOffset = receivedOffset + na.count
                    if self.currentPageSize < 50 {
                        self.currentPageSize = 50
                    }
                    if na.count != 0 {
                        self.getNextSearchItems()
                    } else {
                        self.searchTasksCount -= 1
                        print("finished loading search items for '\(searchString ?? "<none>")\', total: \(self.currentSearchOffset) items")
                        self.onSearchItemsLoadFinished()
                    }
                } else {
                    self.searchTasksCount -= 1
                    self.onLoadingError()
                    self.onSearchItemsLoadFinished()
                    print("finished loading search items for '\(searchString ?? "<none>")\', total: \(receivedOffset) items")
                }
            }
        }
    }
    
    func getNewsItems(offset:Int, count:Int?, search:String? = nil, completion:@escaping ([NewsItem]?, Int, Int, String?)->()) {
        
        Client.shared.getFeed(type:itemType, offset: offset, count: count, search: search) { (dataArray, totalItems, error) in
            if let arrayOfDicts = dataArray {
                var items = [NewsItem]()
                items.reserveCapacity(arrayOfDicts.count)
                
                var ind = 0;
                arrayOfDicts.forEach({ (dict) in
                    if ind % 4 == 0 {
                        items.append(self.adNewsItem())
                    }
                    if let item = self.newsItem(dict: dict as! [AnyHashable : Any]) {
                        items.append(item)
                    }
                    ind += 1
                })
                completion(items, offset, totalItems, search)
            } else {
                completion(nil, 0, 0, nil)
                
                if let error = error {
                    self.reportError(error: error)
                }
            }
        }
    }
    
    func getPostBy(id:Int, completion:@escaping (NewsOpenPost?, Error?)->()) {
        Client.shared.getPost(id: id, type:itemType) { (dataArray, count, error) in
            if let array = dataArray as [Any]?, array.count > 0, let dict = array[0] as? [String:Any] {
                if let title = (dict["title"] as? [AnyHashable:Any])?["rendered"] as? String,
                   let content =  (dict["content"] as? [AnyHashable:Any])?["rendered"] as? String,
                   let id = dict["id"] as? Int {
                    
                    let date = dict["date"] as? String ?? ""
                    let link = dict["link"] as? String ?? ""
                    
                    let post = NewsOpenPost(id: id, title: self.filterHtml(title), content: content, htmlURL: link, date: date)
                    completion(post, nil)
                    return
                }
            }
            let error = NSError(domain: kNetworkErrorDomain, code: 1003, userInfo: nil)
            completion(nil, error)
        }
    }
    
    func getPostBy(slug:String, completion:@escaping (NewsOpenPost?, Error?)->()) {
        Client.shared.getPost(slug: slug, type:itemType) { (dataArray, count, error) in
            if let array = dataArray as [Any]?, array.count > 0, let dict = array[0] as? [String:Any] {
                if let title = (dict["title"] as? [AnyHashable:Any])?["rendered"] as? String,
                   let content =  (dict["content"] as? [AnyHashable:Any])?["rendered"] as? String,
                   let id = dict["id"] as? Int {
                    
                    let date = dict["date"] as? String ?? ""
                    let link = dict["link"] as? String ?? ""
                    let post = NewsOpenPost(id: id, title: self.filterHtml(title), content: content, htmlURL: link, date: date)
                    completion(post, nil)
                    return
                }
            }
            let error = NSError(domain: kNetworkErrorDomain, code: 1003, userInfo: nil)
            completion(nil, error)
        }
    }
    
    
    private func reportError(error:Error) {
        print("Error during news list request:")
        print(error)
        print("Total loaded: \(newsItems.count)")
    }
    
//    private var itemCount = 0
    
    private func newsItem(dict:[AnyHashable:Any]) -> NewsItem? {
//        itemCount += 1
        if let title = (dict["title"] as? [AnyHashable:Any])?["rendered"] as? String,
            let id = dict["id"] as? Int {
            let excerpt = (dict["excerpt"] as? [AnyHashable:Any])?["rendered"] as? String ?? ""
            let date = dict["date"] as? String ?? ""
            let url = dict["link"] as? String ?? ""
            return NewsItem(id:id, title:filterHtml(title), shortText:filterHtml(excerpt), date:date, views:0, url:url, type: .newsType)
        }
        return nil;
    }
    
    private func adNewsItem() -> NewsItem {
//        itemCount += 1
        let index = currentAdImageIndex
        if currentAdImageIndex >= adImages.count - 1 {
            currentAdImageIndex = 0
        } else {
            currentAdImageIndex += 1
        }
        let file = adImages[index].lastPathComponentWithoutExtension().lowercased()
        let title = adImageCountryMap[file] ?? ""
        return NewsItem(id: 0, title: title, shortText: "", date: "", views: 0, url: "https://gofrotech.ru", imageURL: nil, adImage: adImages[index], type: .adsType)
    }
    
    private func filterHtml(_ string:String) -> String {
        let regexString = "&[#]?\\w{3,4};|<[/]?[p|b]>|\n"
        if let regex = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length:  string.count), withTemplate: "").replacingOccurrences(of: "<br>", with: "")
            return modString
        }
        return ""
    }
}

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
            return "Board"
        default:
            return "News"
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

extension NSNotification.Name {
    public static let NewsSourceItemsUpdated = NSNotification.Name("NewsSourceItemsUpdated")
}

class NewsSource: NSObject {

   private let kPartnerImagesDIR = "images/partners"
    private let kImagesEXTPNG = "png"
    let adImageCountryMap = [
        "1" : "ПЛОСКОВЫСЕКАТЕЛЬНЫЕ АВТОМАТЫ (ASAHI)",
        "2" : "ОБОРУДОВАНИЕ ДЛЯ ПЕЧАТИ (CELLMACH)",
        "3" : "ТРАНСПОРТНЫЕ СИСТЕМЫ (FOSSALUZZA)",
        "4" : "КОМПЛЕКТНЫЕ ГОФРОАГРЕГАТЫ (FOSBER)",
        "5" : "УПАКОВОЧНОЕ ОБОРУДОВАНИЕ (MOSCA)",
        "6" : "ОБОРУДОВАНИЕ ДЛЯ ПРОИЗВОДСТВА И СБОРКИ РЕШЕТКИ ИЗ ГОФРИРОВАННОГО КАРТОНА/КАРТОНА ХРОМ-ЭРЗАЦ (PREMIER)",
        "7" : "АВТОМАТИЧЕСКИЕ КЛЕЕВЫЕ КУХНИ (SRP)",
        "8" : "ВЫСОКОСКОРОСТНЫЕ КОНВЕРТНЫЕ ЛИНИИ И ГОФРОАГРЕГАТЫ (TCY)",
        "9" : "МАКУЛАТУРНЫЕ ПРЕССЫ (TECHGENE)",
        "10" : "МНОГОТОЧЕЧНЫЕ ФАЛЬЦЕВАЛЬНО-СКЛЕИВАЮЩИЕ ЛИНИИ (VEGA)",
        "11" : "ТРАНСПОРТНЫЕ СИСТЕМЫ (WSA)"
    ]
    
    lazy var adImages = Bundle.main.paths(forResourcesOfType: self.kImagesEXTPNG, inDirectory: self.kPartnerImagesDIR)
    
    let itemType:SourceCategory
    
    var currentPageSize = 16
    var currentOffset = 0
    
    var currentSearchOffset = 0
    
    var currentAdImageIndex = 0
    
    var newsItems = [NewsItem]()
    var searchItems = [NewsItem]()
    
    private var backgroundTask = BackgroundTask(name:"news.source")
    private var loadInProgress = false {
        didSet {
            backgroundTask.inProgress = loadInProgress
        }
    }
    
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
        NotificationCenter.default.post(name: .NewsSourceItemsUpdated, object: nil)
    }
    
    private func onSearchItemsChange() {
        self.onItemsChange()
    }
    
    func reload() {
        if loadInProgress == true {
            return
        }
        currentOffset = 0;
        newsItems.removeAll()
        onItemsChange()
        loadInProgress = true
        getNextItems(offset:currentOffset, count: currentPageSize, recursively: true)
    }
    
    func reloadSearch() {
        currentSearchOffset = 0;
        currentPageSize = 10;
        searchItems.removeAll()
        onSearchItemsChange()
        loadInProgress = true
        getNextSearchItems()
    }
    
    
    private func appendItems(items:[NewsItem], offset:Int) {
        if (offset >= self.newsItems.count) {
            self.newsItems.append(contentsOf: items)
        } else {
            self.newsItems.replaceSubrange(offset..<self.newsItems.count, with: items)
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
                        print("finished loading items, total: \(self.currentOffset) items")
                    }
                } else {
                    self.loadInProgress = false
                    print("finished loading items, total: \(self.currentOffset) items")
                }
            }
        }
    }
    
    func getNextSearchItems() {
        self.getNewsItems(offset: currentSearchOffset, count: currentPageSize, search: searchTerm) { [weak self] (newsArray, receivedOffset, totalItems, searchString) in
            if let self = self {
                if let na = newsArray {
                    if let ss = searchString, self.searchTerm == ss {
                        self.searchItems.append(contentsOf: na)
                        self.onSearchItemsChange()
                    }
                    self.currentSearchOffset = receivedOffset + na.count
                    let oldPageSize = self.currentPageSize;
                    if self.currentPageSize < 50 {
                        self.currentPageSize = 50
                    }
                    if na.count == oldPageSize {
                        self.getNextSearchItems()
                    } else {
                        self.loadInProgress = false
                    }
                } else {
                    self.loadInProgress = false
                    print("finished loading search items, total: \(self.currentSearchOffset + 1) items")
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
            let date = dict["date_gmt"] as? String ?? ""
            let url = dict["link"] as? String ?? ""
            return NewsItem(id:id, title:filterHtml(title), shortText:filterHtml(excerpt), date:filterDate(date), views:0, url:url, type: .newsType)
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
            let modString = regex.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length:  string.count), withTemplate: "")
            return modString
        }
        return ""
    }
    
    private func filterDate(_ string:String) -> String {
        return string.replacingOccurrences(of: "T", with: " ")
    }
}

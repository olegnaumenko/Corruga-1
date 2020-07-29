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
    
    var currentPageSize = 12
    var currentPageIndex = 0
    
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
        currentPageIndex = 0;
        newsItems.removeAll()
        onItemsChange()
        loadInProgress = true
        getNextItems()
    }
    
    func reloadSearch() {
        currentPageIndex = 0;
        currentPageSize = 10;
        searchItems.removeAll()
        onSearchItemsChange()
        loadInProgress = true
        getNextSearchItems()
    }
    
    func getNextItems() {
        
        self.getNewsItems(pageIndex: currentPageIndex, pageItems: currentPageSize, search: nil) { [weak self] (newsArray, receivedPageIndex, totalItems, searchString) in
            if let self = self {
                if let na = newsArray {
                    self.newsItems.append(contentsOf: na)
                    self.onItemsChange()
                    self.currentPageIndex = receivedPageIndex + 1
//                    let oldPageSize = self.currentPageSize;
                    if self.currentPageSize < 45 {
                        self.currentPageSize = 45
                    }
//                    print("got items: ", receivedPageIndex, na.count)
//                    if na.count == oldPageSize {
                    self.getNextItems()
//                    } else {
//                        self.loadInProgress = false
//                    }
                } else {
                    self.loadInProgress = false
                    print("finished loading items, total: \(self.currentPageIndex + 1) pages")
                }
            }
        }
    }
    
    func getNextSearchItems() {
        self.getNewsItems(pageIndex: currentPageIndex, pageItems: currentPageSize, search: searchTerm) { [weak self] (newsArray, receivedPageIndex, totalItems, searchString) in
            if let self = self {
                if let na = newsArray {
                    if let ss = searchString, self.searchTerm == ss {
                        self.searchItems.append(contentsOf: na)
                        self.onSearchItemsChange()
                    }
                    self.currentPageIndex = receivedPageIndex + 1
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
                    print("finished loading search items, total: \(self.currentPageIndex + 1) pages")
                }
            }
        }
    }
    
    func getNewsItems(pageIndex:Int, pageItems:Int, search:String? = nil, completion:@escaping ([NewsItem]?, Int, Int, String?)->()) {
        
        Client.shared.getFeed(type:itemType, pageIndex: pageIndex, itemsInPage: pageItems, search: search) { (dataArray, totalItems, error) in
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
                completion(items, pageIndex, totalItems, search)
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
    }
    
    private func newsItem(dict:[AnyHashable:Any]) -> NewsItem? {
        
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

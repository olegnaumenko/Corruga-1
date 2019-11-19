//
//  Client.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import Networking
import Reachability

struct NetworkProgressNotifier {
    
    private var openConnections:Int = 0
    
    mutating func increment() {
        openConnections+=1
        if openConnections == 1 {
            didChange()
        }
    }
    
    mutating func decrement() {
        openConnections-=1
        if (openConnections <= 0) {
            openConnections = 0
            didChange()
        }
    }
    
    private func didChange() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = (openConnections != 0)
    }
}

final class Client {
    
    static let shared = Client()
    
    
    private static let boardAPIURL = "https://market.gofro.expert/wp-json/wp/v2"
    private static let newsAPIURL  = "https://novosti.gofro.expert/wp-json/wp/v2"
    private static let youTubeAPIURL = "https://www.googleapis.com/youtube/v3"
    
    private let reachability:Reachability!

    private let gofroExpertPlaylistId = "UUK_ntS5EmUV5jiy6Es2mTgA"
    private let youTubeV3APIKey = "AIzaSyA3ab1v-VGofBAetGA4l_QUtHzmMlTK28c"
    
    private let ytClient = Networking(baseURL: youTubeAPIURL)
    private let newsClient = Networking(baseURL: newsAPIURL)
    private let boardClient = Networking(baseURL: boardAPIURL)
    
    private var indicatorNotifier = NetworkProgressNotifier()
    
    private init() {
        do {
            try! self.reachability = Reachability()
            try self.reachability.startNotifier()
        } catch let error {
            print(error)
            fatalError()
        }
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
    func isNetworkReachable() -> Bool {
        return self.reachability.connection != .unavailable
    }
    
    func getPlaylistVideos(nextPageToken:String?, resultsPerPage:Int, completion:@escaping ([String:Any]?, Error?)->())
    {
        let bundleId = Bundle.main.bundleIdentifier
        ytClient.headerFields = ["X-Ios-Bundle-Identifier":bundleId ?? ""]
        
        var params = [
            "key" : youTubeV3APIKey,
            "playlistId" : gofroExpertPlaylistId,
            "part" : "snippet",
            "maxResults" : resultsPerPage,
            ] as [String: AnyObject]
        
        if let npt = nextPageToken {
            params["pageToken"] = npt as AnyObject
        }
        
        self.indicatorNotifier.increment()
        
        ytClient.get("/playlistItems", parameters: params) { (result) in
            
            switch result {
            case .success(let response):
                
                completion(response.dictionaryBody, nil)
                
            case .failure(let response):
                
                let json = response.dictionaryBody
                print("Error during request:")
                print(json)
                completion(nil, response.error)
            }
            self.indicatorNotifier.decrement()
        }
    }
    
    func getFeed(type:ItemType, pageIndex:Int? = nil, itemsInPage:Int? = nil, search:String? = nil, completion:@escaping ([Any]?, Error?) -> ())
    {
        var params:[String:Any] = ["per_page":10];
             
        let client = type == .newsItemType ? newsClient : boardClient
        
        if let pgIndex = pageIndex, pgIndex > 0 {
            params["page"] = pgIndex + 1
        }
        if let itemsCount = itemsInPage {
            params["per_page"] = itemsCount;
        }
        if let searchTerm = search, searchTerm.count > 0 {
            params["search"] = searchTerm
        }
        self.indicatorNotifier.increment()
        
        client.get("/posts", parameters:params) { (jsonResult) in
            switch jsonResult {
            case .success(let response):
                
                completion(response.arrayBody, nil)
                
            case .failure(let response):
                
                completion(nil, response.error)
            }
            self.indicatorNotifier.decrement()
        }
    }
    
    
//    func getNewsFeed(pageIndex:Int? = nil, itemsInPage:Int? = nil, search:String? = nil, completion:@escaping ([Any]?, Error?) -> ()) {
//
//        var params:[String:Any] = ["per_page":10];
//
//        if let pgIndex = pageIndex, pgIndex > 0 {
//            params["page"] = pgIndex + 1
//        }
//        if let itemsCount = itemsInPage {
//            params["per_page"] = itemsCount;
//        }
//        if let searchTerm = search, searchTerm.count > 0 {
//            params["search"] = searchTerm
//        }
//
//        newsClient.get("/posts", parameters:params) { (jsonResult) in
//            switch jsonResult {
//            case .success(let response):
//
//                completion(response.arrayBody, nil)
//
//            case .failure(let response):
//
//                print("Error during news list request:")
//                print(response.error)
//                completion(nil, response.error)
//            }
//        }
//    }
//
//    func getBoardFeed(pageIndex:Int? = nil, itemsInPage:Int? = nil, completion:@escaping ([Any]?, Error?) -> ()) {
//
//        var params = ["per_page":10];
//
//        if let pgIndex = pageIndex, pgIndex > 0 {
//            params["page"] = pgIndex + 1
//        }
//        if let itemsCount = itemsInPage {
//            params["per_page"] = itemsCount;
//        }
//        boardClient.get("/posts", parameters:params) { (jsonResult) in
//            switch jsonResult {
//            case .success(let response):
//
//                completion(response.arrayBody, nil)
//
//            case .failure(let response):
//
//                print("Error during news list request:")
//                print(response.error)
//                completion(nil, response.error)
//            }
//        }
//    }
    
//
//    func getPlaylistVideos( completion:@escaping ([String:Any]?, Error?)->())
//    {
//        let bundleId = Bundle.main.bundleIdentifier
//        ytClient.headerFields = ["X-Ios-Bundle-Identifier":bundleId ?? ""]
//
//        let params = [
//            "key" : youTubeV3APIKey,
//            "playlistId" : gofroExpertPlaylistId,
//            "part" : "snippet",
//            "maxResults" : 50,
////            "pageToken" : "0"
//            ] as [String: AnyObject]
//
//        ytClient.get("/playlistItems", parameters: params) { (result) in
//
//            switch result {
//            case .success(let response):
//
//                completion(response.dictionaryBody, nil)
//
//            case .failure(let response):
//
//                let json = response.dictionaryBody
//                print("Error during request:")
//                print(json)
//                completion(nil, response.error)
//            }
//        }
//    }

    
//    func getNewsFeed(completion:@escaping ([Any]?, Error?) -> ()) {
//        let params = ["per_page":100]
//        newsClient.get("/posts", parameters:params) { (jsonResult) in
//            switch jsonResult {
//            case .success(let response):
//
//                completion(response.arrayBody, nil)
//
//            case .failure(let response):
//
//                print("Error during news list request:")
//                print(response.error)
//                completion(nil, response.error)
//            }
//        }
        
//        newsClient.downloadData("/posts") { (dataResult) in
//            switch dataResult {
//            case .success(let response):
//
//                completion(response.data, nil)
//
//            case .failure(let response):
//
//                print("Error during news list request:")
//                print(response.error)
//                completion(nil, response.error)
//            }
//        }
//    }
}

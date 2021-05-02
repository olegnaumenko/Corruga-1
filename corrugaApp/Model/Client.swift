//
//  Client.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

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
//    https://novosti.gofro.expert/wp-json/wp/v2
    private static let newsAPIURL  = "https://gofro.expert/wp-json/wp/v2"//"
//    private static let newsAPIURL  = "https://novosti.gofro.expert/wp-json/wp/v2"
    private static let youTubeAPIURL = "https://www.googleapis.com/youtube/v3"
    
//    private let reachability:Reachability!

    private let gofroExpertPlaylistId = "UUK_ntS5EmUV5jiy6Es2mTgA"
    private let youTubeV3APIKey = "AIzaSyA3ab1v-VGofBAetGA4l_QUtHzmMlTK28c"
    
    private let client:NetworkStackProtocol
    
    private var indicatorNotifier = NetworkProgressNotifier()
    
    private init() {
        self.client = Network()
    }
    
    init(stack:NetworkStackProtocol) {
        self.client = stack
    }
    
    func isNetworkReachable() -> Bool {
        return self.client.networkIsAvailable
    }
    
    func getPlaylistVideos(nextPageToken:String?, resultsPerPage:Int, completion:@escaping ([String:Any]?, Error?)->())
    {
        let bundleId = Bundle.main.bundleIdentifier
        let headers = ["X-Ios-Bundle-Identifier":bundleId ?? ""]
        
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
        
        client.getJson(Client.youTubeAPIURL + "/playlistItems", parameters: params, headerFields: headers, completion: { (result) in
            
            switch result {
            case .Success(let resource, _):
                
                if let dict = resource as? [String:Any] {
                    completion(dict, nil)
                }
                
            case .Failure(let error):
                
                print("Error on YT request: ", error)
                completion(nil, error)
            }
            self.indicatorNotifier.decrement()
        })
    }
    
    func getFeedAfter(type:SourceCategory, dateString:String, completion:@escaping ([Any]?, Int, Error?) -> ()) {
        var params = [String:Any]();
        
        let urlString = type == .news ? Client.newsAPIURL : Client.boardAPIURL
        
        params["after"] = dateString
        params["_fields"] = ["id","date"]
        
        client.getJson("\(urlString)/posts", parameters: params, headerFields: nil) { (networkResult) in
            
            switch networkResult {
            case .Success(let resource, let response):
                let totalHeader = response.allHeaderFields["x-wp-total"] as? String
                let totalItems:Int = (totalHeader == nil ? 0 : Int(totalHeader!) ?? 0)
                if let array = resource as? [Any] {
                    completion(array, totalItems, nil)
                }
            case .Failure(let error):
                completion(nil, 0, error)
                print("error in response: ", error)
            }
        }
    }
    
    func getFeed(type:SourceCategory, offset:Int? = nil, count:Int? = nil, search:String? = nil, completion:@escaping ([Any]?, Int, Error?) -> ())
    {
        var params = [String:Any]();
        
        let urlString = type == .news ? Client.newsAPIURL : Client.boardAPIURL
        
        if let offset = offset, offset > 0 {
            params["offset"] = offset
        }
        if let itemsCount = count {
            params["per_page"] = itemsCount;
        }
        if let searchTerm = search, searchTerm.count > 0 {
            params["search"] = searchTerm
        }
        params["categories"] = 1
        params["_fields"] = ["id","title","excerpt","date","link"]
        params["status"] = "publish"
        params["type"] = "post"
        
        self.indicatorNotifier.increment()
        
        client.getJson("\(urlString)/posts", parameters:params, headerFields: nil) { (networkResult) in
            
            switch networkResult {
            case .Success(let resource, let response):
                let totalHeader = response.allHeaderFields["x-wp-total"] as? String
                let totalItems:Int = (totalHeader == nil ? 0 : Int(totalHeader!) ?? 0)
                if let array = resource as? [Any] {
                    completion(array, totalItems, nil)
                }
            case .Failure(let error):
                completion(nil, 0, error)
                print("error in response: ", error)
            }
            self.indicatorNotifier.decrement()
        }
    }
    
    func getPost(id:Int, type:SourceCategory, completion:@escaping ([Any]?, Int, Error?) -> ()) {
        var params = [String:Any]();
        
        let urlString = (type == .news ? Client.newsAPIURL : Client.boardAPIURL) + "/posts/\(id)"
        
        params["_fields"] = ["id", "title", "excerpt", "date_gmt", "link", "content"]
        
        self.indicatorNotifier.increment()
        
        client.getJson(urlString, parameters:params, headerFields: nil) { (jsonResult) in
            
            switch jsonResult {
            case .Success(let resource, let response):
                let totalHeader = response.allHeaderFields["x-wp-total"] as? String
                let totalItems:Int = (totalHeader == nil ? 0 : Int(totalHeader!) ?? 0)
                if let array = resource as? [Any] {
                    completion(array, totalItems, nil)
                } else if let dict = resource as? [String:Any] {
                    completion([dict], totalItems, nil)
                } else {
                    let error = NSError(domain: kNetworkErrorDomain, code: 1002, userInfo: nil)
                    completion(nil, 0, error)
                }
            case .Failure(let error):
                completion(nil, 0, error)
                print("error in response: ", error)
            }
            self.indicatorNotifier.decrement()
        }
    }
}

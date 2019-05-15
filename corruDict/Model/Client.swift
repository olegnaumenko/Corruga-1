//
//  Client.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import Networking

class Client {
    
    static let shared = Client()
    
    static let newsURL = "https://novosti.gofro.expert/wp-json/wp/v2"// http://novosti.gofro.expert"
    
    static let YouTubeAPIBaseURL = "https://www.googleapis.com/youtube/v3"
//    static let baseURL = "https://usound.in.ua"
    
    private let gofroExpertPlaylistId = "UUK_ntS5EmUV5jiy6Es2mTgA"
    private let youTubeV3APIKey = "AIzaSyA3ab1v-VGofBAetGA4l_QUtHzmMlTK28c"
    
    let ytClient = Networking(baseURL: YouTubeAPIBaseURL)
    let newsClient = Networking(baseURL: newsURL)
    
    
    func getPlaylistVideos( completion:@escaping ([String:Any]?, Error?)->())
    {
        let bundleId = Bundle.main.bundleIdentifier
        ytClient.headerFields = ["X-Ios-Bundle-Identifier":bundleId ?? ""]
        
        let params = [
            "key" : youTubeV3APIKey,
            "playlistId" : gofroExpertPlaylistId,
            "part" : "snippet",
            "maxResults" : 50,
            ] as [String: AnyObject]
        
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
        }
    }
    
    func getNewsFeed(completion:@escaping ([Any]?, Error?) -> ()) {
        let params = ["per_page":100]
        newsClient.get("/posts", parameters:params) { (jsonResult) in
            switch jsonResult {
            case .success(let response):
                
                completion(response.arrayBody, nil)
                
            case .failure(let response):
                
                print("Error during news list request:")
                print(response.error)
                completion(nil, response.error)
            }
        }
        
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
    }
}

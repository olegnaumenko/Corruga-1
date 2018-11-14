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
    
    static let YouTubeAPIBaseURL = "https://www.googleapis.com/youtube/v3"
    static let baseURL = "https://usound.in.ua"
    
    private let gofroExpertPlaylistId = "UUK_ntS5EmUV5jiy6Es2mTgA"
    private let youTubeV3APIKey = "AIzaSyA3ab1v-VGofBAetGA4l_QUtHzmMlTK28c"
    
    let ytClient = Networking(baseURL: YouTubeAPIBaseURL)
//    let client = Networking(baseURL: baseURL)
    
    
//    func getVideos( completion:@escaping ([[String:String]]?, Error?)->())
//    {
//        client.get("/videos.json") { (result) in
//                
//            switch result {
//            case .success(let response):
//                
//                let json = response.arrayBody
//                
//                if let data = json as? [[String:String]] {
//                    completion(data, nil)
//                } else {
//                    completion(nil, NSError(domain: "com.corruga.error", code: 42, userInfo: ["description":"unknown response data"]))
//                }
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
}

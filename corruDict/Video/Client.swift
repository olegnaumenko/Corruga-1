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
    
    static let baseURL = "https://usound.in.ua"
//    static let baseURL = "https://www.dropbox.com/s/0xf9s15t4n5f57v"
    let client = Networking(baseURL: baseURL)
    
    
    func getVideos( completion:@escaping ([[String:String]]?, Error?)->())
    {
        client.get("/videos.json") { (result) in
            
            switch result {
            case .success(let response):
                
                let json = response.arrayBody
                
                if let data = json as? [[String:String]] {
                    completion(data, nil)
                } else {
                    completion(nil, NSError(domain: "com.corruga.error", code: 42, userInfo: ["description":"unknown response data"]))
                }
                
            case .failure(let response):
                
                let json = response.dictionaryBody
                print("Error during request:")
                print(json)
                completion(nil, response.error)
            }
        }
    }
}

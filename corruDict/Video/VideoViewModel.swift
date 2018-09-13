//
//  VideoViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

struct VideoViewModel:Equatable {
    
    static let urlKey = "url"
    static let descriptionKey = "desc"
    static private let youTubeVideoURL = "https://www.youtube.com/watch?v="
    
    let url:String
    let description:String
    
    var youTubeId:String? {
        get {
            return self.url.components(separatedBy: VideoViewModel.youTubeVideoURL).last
        }
    }
    
    init?(dictionary:[String:String]) {
        if let url = dictionary[VideoViewModel.urlKey] {
            self.url = url
        } else {
            return nil
        }
        if let desc = dictionary[VideoViewModel.descriptionKey] {
            self.description = desc
        } else {
            return nil
        }
    }

    static public func == (lhs: VideoViewModel, rhs: VideoViewModel) -> Bool
    {
        return lhs.url == rhs.url
    }
    
}

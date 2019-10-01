//
//  VideoViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

protocol VideoItemStorageModelProtocol {
    var title:String {get}
    var descriptionText:String {get}
    var videoId:String {get}
    
    var thumbDefaultURL:String {get}
    var thumbMediumURL:String {get}
    var thumbHighURL:String {get}
    var thumbStandardURL:String {get}
    var thumbMaxresURL:String {get}
}

struct VideoItemViewModel:Equatable {
    
    
    //playlist : https://www.youtube.com/playlist?list=UUK_ntS5EmUV5jiy6Es2mTgA
    
//    static let urlKey = "url"
//    static let descriptionKey = "desc"
//    static private let youTubeVideoURL = "https://www.youtube.com/watch?v="
//
    let title:String
    let descriptionText:String
    
    let largeTHumbURL:String
    let mediumThumbURL:String
    let smallThumbURL:String
    
    let videoId:String
    
    init(storageItem:VideoItemStorageModelProtocol) {

        self.title = storageItem.title
        self.descriptionText = storageItem.descriptionText
        self.videoId = storageItem.videoId
        self.mediumThumbURL = storageItem.thumbMediumURL
        self.smallThumbURL = storageItem.thumbDefaultURL
        self.largeTHumbURL = storageItem.thumbHighURL
    }

    static public func == (lhs: VideoItemViewModel, rhs: VideoItemViewModel) -> Bool
    {
        return lhs.videoId == rhs.videoId
    }
    
    
}

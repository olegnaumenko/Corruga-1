//
//  VideoItemEntity.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/14/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

struct VideoItemEntity : VideoItemStorageModelProtocol {

    var videoId: String {
        return resourceVideoId
    }
    
    var index = 0
    var id = ""
    
    var publishedAt = ""
    var title = ""
    var descriptionText = ""
    
    var thumbDefaultURL = ""
    var thumbMediumURL = ""
    var thumbHighURL = ""
    var thumbStandardURL = ""
    var thumbMaxresURL = ""
    
    var channelTitle = ""
    var channelId = ""
    var playlistId = ""
    var position = 0
    var resourceIdKind = ""
    var resourceVideoId = ""
    
}

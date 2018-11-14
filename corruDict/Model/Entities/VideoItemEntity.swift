//
//  VideoItemEntity.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/14/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class VideoItemEntity : Object, VideoItemStorageModelProtocol {

    var videoId: String {
        return resourceVideoId
    }
    
    @objc dynamic var index = 0
    @objc dynamic var id = ""
    
    @objc dynamic var publishedAt = ""
    @objc dynamic var title = ""
    @objc dynamic var descriptionText = ""
    
    @objc dynamic var thumbDefaultURL = ""
    @objc dynamic var thumbMediumURL = ""
    @objc dynamic var thumbHighURL = ""
    @objc dynamic var thumbStandardURL = ""
    @objc dynamic var thumbMaxresURL = ""
    
    @objc dynamic var channelTitle = ""
    @objc dynamic var channelId = ""
    @objc dynamic var playlistId = ""
    @objc dynamic var position = 0
    @objc dynamic var resourceIdKind = ""
    @objc dynamic var resourceVideoId = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

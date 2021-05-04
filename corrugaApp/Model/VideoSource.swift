//
//  VideoSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/14/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
//import RealmSwift

extension NSNotification.Name {
    public static let VideoSourceItemsStartedLoading = NSNotification.Name("VideoSourceItemsStartedLoading")
    public static let VideoSourceItemsUpdated = NSNotification.Name("VideoSourceItemsUpdated")
    public static let VideoSourceItemsLoadingError = NSNotification.Name("VideoSourceItemsLoadingError")
}

class VideoSource {
    
    static let shared = VideoSource()
    
//    let realm:Realm
//    var observeToken:NotificationToken?
    
    private var backgroundTask = BackgroundTask(name: "videos.source")
    private var loadInProgress = false
    private var nextPageToken:String?
    private var currentResultsPerPage = 10
    var totalItems:Int = 0
    var videoEntities = [VideoItemEntity]()// Results<VideoItemEntity>?
    var onEntitiesChange = {}
    
    private init() {
//        var conf = Realm.Configuration.defaultConfiguration
//        conf.schemaVersion = 4
//        conf.inMemoryIdentifier = "videos"
//        conf.migrationBlock = { migration, oldSchemaVersion in
//            print("Migration from version " + String(oldSchemaVersion))
//        }
//        try! realm = Realm(configuration: conf)
        
//        self.videoEntities = self.realm.objects(VideoItemEntity.self).sorted(byKeyPath: "index")
//        self.observeToken = self.videoEntities?.observe({ [unowned self] (change) in
//            self.onEntitiesChange()
//        })
    }
    
    func reload() {
        self.nextPageToken  = nil
        self.videoEntities.removeAll()
        self.onEntitiesChange()
        self.getNextVideosPage()
    }
    
    private func report(error:Error) {
        print("Error fetching playlist items: " + error.localizedDescription)
        
    }
    
    func getNextVideosPage(recursively:Bool = false) {
        
        loadInProgress = true
        Client.shared.getPlaylistVideos(nextPageToken: self.nextPageToken, resultsPerPage: self.currentResultsPerPage) { (playlistDict, error) in
        
            if (error != nil) {
                self.report(error: error!)
                
            } else if let playlistDictionary = playlistDict {
                
                self.nextPageToken = playlistDictionary["nextPageToken"] as? String
                
                if let items = playlistDictionary["items"] as? [[String:Any]] {
                    
                    var entities = [VideoItemEntity]()
                    entities.reserveCapacity(items.count)
                    
                    var index = 0;
                    items.forEach({ (item) in
                        entities.append(self.createVideoEntity(dict: item, index: index))
                        index += 1
                    })

                    self.videoEntities.append(contentsOf: entities)
                    self.onEntitiesChange()
                    
//                    print("got video items: \(entities.count), total: \(self.videoEntities.count)")
                    
                    if let totalResults = (playlistDictionary["pageInfo"] as? [String:Any])?["totalResults"] as? Int,
                        totalResults <= self.videoEntities.count {
                        self.loadInProgress = false
                        return
                    }
                    
                    if self.currentResultsPerPage < 50 {
                        self.currentResultsPerPage = 50
                    }
                    if (recursively == true) {
                        self.getNextVideosPage(recursively: true)
                    }
                }
            }
        }
    }
    
    private func createVideoEntity(dict:[String:Any], index:Int) -> VideoItemEntity {
        
        var videoEntity = VideoItemEntity()
        videoEntity.id = dict["id"] as? String ?? ""
        
        
        if let snippet = dict["snippet"] as? [String:Any] {
            
            if let resourceId = snippet["resourceId"] as? [String:String] {
                videoEntity.resourceIdKind = resourceId["kind"] ?? ""
                videoEntity.resourceVideoId = resourceId["videoId"] ?? ""
            }
            
            videoEntity.playlistId = snippet["playlistId"] as? String ?? ""
            videoEntity.channelTitle = snippet["channelTitle"] as? String ?? ""
            videoEntity.position = snippet["position"] as? Int ?? 0
            
            videoEntity.index = videoEntity.position
            
            videoEntity.title = snippet["title"] as? String ?? ""
            videoEntity.channelId = snippet["channelId"] as? String ?? ""
            videoEntity.publishedAt = snippet["publishedAt"] as? String ?? ""
            videoEntity.descriptionText = snippet["description"] as? String ?? ""
            
            if let thumbinails = snippet["thumbnails"] as? [String:Any] {
                
                if let defaultDict = thumbinails["default"] as? [String:Any] {
                    videoEntity.thumbDefaultURL = defaultDict["url"] as? String ?? ""
                }
                if let standardDict = thumbinails["standard"] as? [String:Any] {
                    videoEntity.thumbStandardURL = standardDict["url"] as? String ?? ""
                }
                if let mediumDict = thumbinails["medium"] as? [String:Any] {
                    videoEntity.thumbMediumURL = mediumDict["url"] as? String ?? ""
                }
                if let highDict = thumbinails["high"] as? [String:Any] {
                    videoEntity.thumbHighURL = highDict["url"] as? String ?? ""
                }
                if let maxresDict = thumbinails["maxres"] as? [String:Any] {
                    videoEntity.thumbMaxresURL = maxresDict["url"] as? String ?? ""
                }
            }
        }
        return videoEntity
    }
    
    var videoItemsCount:Int {
        return self.videoEntities.count
    }
    
    func videoEntityAtIndex(index:Int) -> VideoItemEntity {
        return self.videoEntities[index]
    }
}

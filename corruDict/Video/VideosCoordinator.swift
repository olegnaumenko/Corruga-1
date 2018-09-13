//
//  VideosCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class VideosCoordinator : NSObject {
    
    let client = Client()
    let videosViewController:VideosViewController
    
    init(videosViewController:VideosViewController) {
        self.videosViewController = videosViewController
        super.init()
        
        self.videosViewController.dataSource = VideosDataSource()
        
        self.videosViewController.onViewDidLoad = { [unowned self] in
            self.client.getVideos { (data, error) in
                if let descriptors = data {
                    self.videosViewController.dataSource?.updateVideos(videoDescriptors: descriptors)
                } else if error != nil {
                    print(error!)
                }
            }
        }
    }
   
}
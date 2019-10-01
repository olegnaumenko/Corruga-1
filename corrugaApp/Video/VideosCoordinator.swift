//
//  VideosCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class VideosCoordinator : BaseFeatureCoordinator {
    
    let videosViewController:VideosViewController
    
    init(videosViewController:VideosViewController) {
        self.videosViewController = videosViewController
        super.init()
        
        self.start(viewController: videosViewController)
    }
}


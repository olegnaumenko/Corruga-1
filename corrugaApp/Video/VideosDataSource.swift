//
//  VideosDataSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class VideosDataSource {
    
    var viewModels = [VideoViewModel]()
    
    var videItemsCount:Int {
        return viewModels.count
    }
    
    func videoItemAtIndex(index:Int) -> VideoViewModel {
        return self.viewModels[index]
    }
    
    var onVideoListUpdated = {}
    
//    func updateVideos(videoDescriptors:[[String:String]])
//    {
//        var array = [VideoViewModel]()
//        for dict in videoDescriptors {
//            if let model = VideoViewModel(dictionary: dict) {
//                array.append(model)
//            }
//        }
//        self.viewModels = array
//        self.onVideoListUpdated()
//    }
    
    func indexOf(viewModel:VideoViewModel) -> Int? {
        return self.viewModels.firstIndex(of: viewModel)
    }
    
}

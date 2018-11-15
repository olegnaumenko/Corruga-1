//
//  VideoTableDataSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
//import SKImageCache
import SwiftyImageCache
import Networking

class VideoTableViewModel: NSObject/*, ImageCacheDelegate*/ {
    
    let dataSource:VideoSource!
    var currentItemIndex = -1;
    
    lazy var client = Networking()
    
    init(dataSource:VideoSource) {
        self.dataSource = dataSource
        super.init()
//        ImageCache.shared.useURLPathing = true
//        ImageCache.shared.useLocalStorage = true
//        ImageCache.shared.delegate = self
    }
    
//    func loadImageAtURL(_ url: URL, completion: @escaping ImageCache.RemoteImageCompletion) -> URLSessionDataTask? {
//
//        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
//            DispatchQueue.main.async {
//                if (error != nil) {
//                    completion(nil, error!)
//                } else if let data = data, let image = UIImage(data: data) {
//                    completion(image, nil)
//                }
//            }
//        }
//
//        task.resume()
//        return task
//    }
    
    func selectedIndexPath() -> IndexPath? {
        if self.currentItemIndex < self.dataSource.videoItemsCount {
            return IndexPath(row: self.currentItemIndex, section: 0)
        }
        return nil
    }
}

extension VideoTableViewModel : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.videoItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoItemTableViewCell.cellId) as? VideoItemTableViewCell {
            
            cell.viewModel = self.cellViewModel(index: indexPath.row)
            cell.setSelected(indexPath.row == self.currentItemIndex, animated: false)
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    func cellViewModel(index:Int) -> VideoItemViewModel? {
        if self.dataSource.videoItemsCount > index {
            return VideoItemViewModel(storageItem: self.dataSource.videoEntityAtIndex(index: index))
        }
        return nil
    }
    
    func tappedCell(indexPath:IndexPath) -> Bool {
        if self.cellViewModel(index: indexPath.row) != nil {
            self.currentItemIndex = indexPath.row
            return true
        } else {
            return false
        }
    }
}

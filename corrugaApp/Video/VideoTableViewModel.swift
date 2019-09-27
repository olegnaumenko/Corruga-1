//
//  VideoTableDataSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import Networking

class VideoTableViewModel: NSObject {
    
//    let videoSource:VideoSource!
//    var currentItemIndex = -1;
    var currentVideoID:String?
    
    var onNeedRefresh = {}
    
//
    override init() {
        super.init()
        VideoSource.shared.onEntitiesChange = { [weak self] in
            self?.onNeedRefresh()
        }
    }
    
//    func selectedIndexPath() -> IndexPath? {
//        if let currentVID = self.currentVideoID, currentVID == self.videoSource.videoItemsCount {
//            return IndexPath(row: self.currentItemIndex, section: 0)
//        }
//        return nil
//    }
}

extension VideoTableViewModel : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoSource.shared.videoItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoItemTableViewCell.cellId) as? VideoItemTableViewCell {
            
            cell.viewModel = self.cellViewModel(index: indexPath.row)
            cell.isSelected = (cell.viewModel.videoId == currentVideoID)
//            cell.setHighlighted(cell.viewModel.videoId == currentVideoID, animated: true)
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    func cellViewModel(index:Int) -> VideoItemViewModel? {
        if VideoSource.shared.videoItemsCount > index {
            return VideoItemViewModel(storageItem: VideoSource.shared.videoEntityAtIndex(index: index))
        }
        return nil
    }
    
//    func tappedCell(indexPath:IndexPath) -> Bool {
//        if self.cellViewModel(index: indexPath.row) != nil {
//            self.currentItemIndex = indexPath.row
//            return true
//        } else {
//            return false
//        }
//    }
}

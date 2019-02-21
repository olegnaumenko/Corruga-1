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
    
    let videoSource:VideoSource!
    var currentItemIndex = -1;
    
    lazy var client = Networking()
    
    init(dataSource:VideoSource) {
        self.videoSource = dataSource
        super.init()
    }
    
    func selectedIndexPath() -> IndexPath? {
        if self.currentItemIndex < self.videoSource.videoItemsCount {
            return IndexPath(row: self.currentItemIndex, section: 0)
        }
        return nil
    }
}

extension VideoTableViewModel : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoSource.videoItemsCount
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
        if self.videoSource.videoItemsCount > index {
            return VideoItemViewModel(storageItem: self.videoSource.videoEntityAtIndex(index: index))
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

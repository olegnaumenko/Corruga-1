//
//  VideoTableDataSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class VideoTableDataSource: NSObject {

    let dataSource:VideosDataSource!
    
    init(dataSource:VideosDataSource) {
        self.dataSource = dataSource
        super.init()
    }
}

extension VideoTableDataSource : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.videItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoItemTableViewCell.cellId) as? VideoItemTableViewCell {
            
            cell.viewModel = self.dataSource.videoItemAtIndex(index: indexPath.row)
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
}

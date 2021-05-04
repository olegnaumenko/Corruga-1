//
//  VideoTableDataSource.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/29/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import AFNetworking
//import Networking

class VideoTableViewModel: NSObject {
    
//    let videoSource:VideoSource!
//    var currentItemIndex = -1;
    var currentVideoID:String?
    
    var onNeedRefresh = {}
    var onReachabilityChange = {}
    
    var isNetworkReachable:Bool {
        get {
            return Client.shared.isNetworkReachable()
        }
    }
    
    override init() {
        super.init()
        VideoSource.shared.onEntitiesChange = { [weak self] in
            self?.onNeedRefresh()
        }
        subscribe()
    }
    
    deinit {
        unSubscribe()
    }
    
    func onViewWillAppear() {
        self.onReachabilityChange()
        VideoSource.shared.getNextVideosPage()
    }
    
    func onOverscroll() {
        VideoSource.shared.getNextVideosPage()
    }
    
    private func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onReachabilityStatus(_:)),
                                               name: .AFNetworkingReachabilityDidChange,
                                               object: nil)
    }
    
    private func unSubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification handlers
    
    var wasUnreachable = false
    
    @objc private func onReachabilityStatus(_ n:Notification) {
        self.onReachabilityChange()
        let reachable = Client.shared.isNetworkReachable()
        if reachable && VideoSource.shared.videoItemsCount == 0 {
            VideoSource.shared.reload()
        }
        self.wasUnreachable = !reachable
    }
    
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

//
//  VideosViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideosViewController: UIViewController {

    @IBOutlet var playerView:YTPlayerView!
    @IBOutlet var tableView:UITableView!
    
    var tableViewDataSource:VideoTableDataSource?
    
    var dataSource:VideosDataSource! {
        didSet {
            self.tableViewDataSource = VideoTableDataSource(dataSource: self.dataSource)
        }
    }
    
    var onViewDidLoad = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Appearance.basicAppColor()
        self.playerView.delegate = self
        
        self.dataSource.onVideoListUpdated = {
            self.tableView.reloadData()
            if let vm = self.dataSource?.viewModels.first {
                self.play(video: vm)
                
                if self.dataSource.videItemsCount > 0,
                    let index = self.dataSource.indexOf(viewModel: vm) {
                    self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
                }
            }
        }        
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = self
        self.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerView.pauseVideo()
    }
    
    func play(video:VideoViewModel) {
        if let youTubeId = video.youTubeId {
            
            AudioSession().activate()
            self.playerView.load(withVideoId: youTubeId)
        }
    }

}

extension VideosViewController : YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        self.playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }
    
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        
        let view = UIView.init(frame: self.playerView.bounds)
        view.backgroundColor = Appearance.basicAppColor()
        return view
    }
}

extension VideosViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = self.dataSource.videoItemAtIndex(index: indexPath.row)
        self.playerView.stopVideo()
        self.play(video: vm)
    }
    
}

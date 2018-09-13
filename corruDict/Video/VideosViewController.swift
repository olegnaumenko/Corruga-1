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
    
    var dataSource:VideosDataSource?
    
    var onViewDidLoad = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Appearance.basicAppColor()
        self.playerView.delegate = self
        
        self.dataSource?.onVideoListUpdated = {
            if let vm = self.dataSource?.viewModels.first {
                self.play(video: vm)
            }
        }
        
        self.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

//
//  VideosViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import youtube_ios_player_helper_swift

class VideosViewController: BaseFeatureViewController {

    @IBOutlet weak var playerView:youtube_ios_player_helper_swift.YTPlayerView!
    @IBOutlet weak var tableView:UITableView!
    
    var isLoaded:Bool = false
    var indicator:UIActivityIndicatorView?
    var shouldPlay:Bool = false
    
    var tableViewModel:VideoTableViewModel!
    
    var videoSource:VideoSource! {
        didSet {
            self.tableViewModel = VideoTableViewModel(dataSource: self.videoSource)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Appearance.basicAppColor()
        self.playerView.delegate = self
        
        self.videoSource.onEntitiesChange = { [weak self] in
            self?.tableView.reloadData()
        }
        self.tableView.dataSource = self.tableViewModel
        self.tableView.delegate = self
        
        self.loadOnStart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoSource.requestListUpdate()
//        updateItemSelection()
    }
    
    private func loadOnStart() {
        if let firstVM = self.tableViewModel?.cellViewModel(index: 0) {
            self.tableViewModel?.currentVideoID = firstVM.videoId
            self.loadItem(video: firstVM)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isLoaded == true {
            self.playerView.pauseVideo()
        }
    }

    
    func loadItem(video:VideoItemViewModel) {
        AudioSession().activate()
        self.isLoaded = self.playerView.load(videoId: video.videoId)
        if (isLoaded) {
            self.tableViewModel.currentVideoID = video.videoId
        }
    }
    
//    func updateItemSelection() {
//        if let indexPath = self.tableViewModel.selectedIndexPath() {
//            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//        }
//    }
}

extension VideosViewController : YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        indicator?.stopAnimating()
        if shouldPlay {
            self.playerView.playVideo()
        }
//        self.updateItemSelection()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        indicator?.stopAnimating()
        print("YT Player Error: \(error)")
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }
    
    @objc(playerViewPreferredInitialLoadingView:) func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView? {
        
        let loadingView = UIView.init(frame: playerView.bounds)
        let parentSize = playerView.bounds.size
        
        let indi = UIActivityIndicatorView(style: .whiteLarge)
        indi.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                      .flexibleLeftMargin, .flexibleRightMargin]
        indi.center = CGPoint(x: parentSize.width / 2, y: parentSize.height / 2)
        
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingView.backgroundColor = UIColor.black
        loadingView.addSubview(indi)
        indi.startAnimating()
        self.indicator = indi
        return loadingView
    }
}

extension VideosViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vm = self.tableViewModel?.cellViewModel(index: indexPath.row) {
            self.tableViewModel?.currentVideoID = vm.videoId
            if self.isLoaded {
                self.playerView.stopVideo()
            }
            self.shouldPlay = true
            self.loadItem(video: vm)
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//    }
}

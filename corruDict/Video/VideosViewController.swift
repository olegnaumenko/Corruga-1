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
    
    var indicator:UIActivityIndicatorView?
    var shouldPlay:Bool = false
    
    private let gofroExpertPlaylistId = "UUK_ntS5EmUV5jiy6Es2mTgA"
    
    var tableViewModel:VideoTableViewModel!
    
    var dataSource:VideoSource! {
        didSet {
            self.tableViewModel = VideoTableViewModel(dataSource: self.dataSource)
        }
    }
    
    var onViewDidLoad = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Appearance.basicAppColor()
        self.playerView.delegate = self
        
        self.dataSource.onEntitiesChange = {
            self.tableView.reloadData()
//            
//            let selectedIndex = 0
//            if let cellViewModel = self.tableViewModel?.cellViewModel(index: selectedIndex) {
//                
//            }
            
//            if let vm = self.dataSource?.viewModels.first {
//                self.play(video: vm)
//
//                if self.dataSource.videItemsCount > 0,
//                    let index = self.dataSource.indexOf(viewModel: vm) {
//                    self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
//                }
//            }
        }
        self.tableView.dataSource = self.tableViewModel
        self.tableView.delegate = self
        self.loadOnStart()
        self.onViewDidLoad()
    }
    
    private func loadOnStart() {
        if let firstVM = self.tableViewModel?.cellViewModel(index: 0) {
            self.tableViewModel?.currentItemIndex = 0
            self.loadItem(video: firstVM)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerView.pauseVideo()
    }

    
    func loadItem(video:VideoItemViewModel) {
        AudioSession().activate()
        self.playerView.load(withVideoId:  video.videoId)
    }
    
    func updateItemSelection() {
        if let indexPath = self.tableViewModel.selectedIndexPath() {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

}

extension VideosViewController : YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        indicator?.stopAnimating()
        if shouldPlay {
            self.playerView.playVideo()
        }
        self.updateItemSelection()
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
    
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        
        let loadingView = UIView.init(frame: playerView.bounds)
        let parentSize = playerView.bounds.size
        
        let indi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
            self.tableViewModel?.currentItemIndex = indexPath.row
            self.playerView.stopVideo()
            self.shouldPlay = true
            self.loadItem(video: vm)
        }
    }
}

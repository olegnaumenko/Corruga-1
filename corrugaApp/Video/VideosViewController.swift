//
//  VideosViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/8/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
//import youtube_ios_player_helper_swift

class VideosViewController: BaseFeatureViewController {

    @IBOutlet weak var playerView:WKYTPlayerView!
    @IBOutlet weak var tableView:UITableView!
    
    var isLoaded:Bool = false
    var indicator:UIActivityIndicatorView?
    var shouldPlay:Bool = false
    
    var tableViewModel:VideoTableViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewModel = VideoTableViewModel()
        
        self.view.backgroundColor = Appearance.basicAppColor()
        self.playerView.delegate = self
        
        self.tableViewModel.onNeedRefresh = { [weak self] in
            self?.tableView.reloadData()
        }
        self.tableView.dataSource = self.tableViewModel
        self.tableView.delegate = self
        
        self.loadOnStart()
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if size.width < size.height && UIApplication.shared.isStatusBarHidden == true {
//
//            coordinator.animate(alongsideTransition: { (context) in
//
//            }) { (context) in
//                UIApplication.shared.setStatusBarHidden(false, with: .fade)
//            }
//        }
//    }
    
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
        self.isLoaded = self.playerView.load(withVideoId: video.videoId)
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

extension VideosViewController : WKYTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        indicator?.stopAnimating()
        if shouldPlay {
            self.playerView.playVideo()
        }
//        self.updateItemSelection()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
    }
    
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
        indicator?.stopAnimating()
        print("YT Player Error: \(error)")
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        return UIColor.black
    }
    
    @objc(playerViewPreferredInitialLoadingView:) func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        
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

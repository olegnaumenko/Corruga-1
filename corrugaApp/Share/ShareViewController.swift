//
//  ShareViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit


class ShareViewController: PresentationReportingViewController {

    let shareLink = "https://corrugated.app.link/185TmpFElV"
    
    var swipeReco:UISwipeGestureRecognizer?
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var shareButton:UIButton!
    @IBOutlet var closeButton:UIButton!
    @IBOutlet var qrImageView:UIImageView!
    
    @IBOutlet var qrTitleLabel:UILabel!
    @IBOutlet var shareTextLabel:UILabel!
    
    @IBOutlet var versionLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shareButton.layer.cornerRadius = 3
        self.shareButton.layer.masksToBounds = true
        titleLabel.text = "share-view-share-title".n10
        shareButton.setTitle("  " + "share-view-share-button-title".n10, for: .normal)
        qrTitleLabel.text = "share-view-point-camera-text".n10
        shareTextLabel.text = "share-view-share-social-text".n10

        let verString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.versionLabel.text = String.init(format: "v. %@", verString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onDismiss()
    }
    
    @objc private func onSwipe(_ sender:UISwipeGestureRecognizer) {
        if sender.state == .recognized {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onShare(_ sender:UIButton) {
        sender.alpha = 0.65
        sender.isEnabled = false
        self.showShareActivity(sender, items: [shareLink], title: nil) { [weak self] (completed, activityType) in
            if (completed) {
                AppAnalytics.shared.logEvent(name:"share_success", params:["activity":activityType ?? "nil"])
                self?.dismiss(animated: true, completion: nil)
            } else {
                AppAnalytics.shared.logEvent(name:"share_decline", params:nil)
                sender.isEnabled = true
                sender.alpha = 1
            }
        }
    }
    
    @objc @IBAction func onClose(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

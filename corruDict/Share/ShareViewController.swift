//
//  ShareViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 11/15/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    let shareLink = "https://corrugated.app.link/185TmpFElV"
    
    var swipeReco:UISwipeGestureRecognizer?
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var shareButton:UIButton!
    @IBOutlet var closeButton:UIButton!
    @IBOutlet var qrImageView:UIImageView!
    
    @IBOutlet var versionLabel:UILabel!
    
    var onShare = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shareButton.layer.cornerRadius = 3
        self.shareButton.layer.masksToBounds = true
        self.shareButton.backgroundColor = Appearance.appTintColor()
//        self.closeButton.layer.cornerRadius = 3
//        self.closeButton.layer.masksToBounds = true
        
        let swipeReco = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        swipeReco.direction = .down
        self.view.addGestureRecognizer(swipeReco)
        self.swipeReco = swipeReco
        
        let verString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.versionLabel.text = String.init(format: "v. %@", verString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightItem = UIBarButtonItem(image: UIImage(named: "qr_close"), style: .plain, target: self, action: #selector(ShareViewController.onClose(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func onSwipe(_ sender:UISwipeGestureRecognizer) {
        if sender.state == .recognized {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onShare(_ sender:UIButton) {
        self.showShareActivity(sender)
    }
    
    @objc @IBAction func onClose(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func showShareActivity(_ sender:UIButton)
    {
        sender.isEnabled = false
        sender.alpha = 0.6
        let message = "This is link to Corruga app download: "
        let activityController = UIActivityViewController(activityItems: [message, shareLink], applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.popoverPresentationController?.sourceRect = sender.frame
        activityController.popoverPresentationController?.backgroundColor = UIColor.lightGray
        
        activityController.completionWithItemsHandler = { [weak self] (activityType, completed, returnedItems, error) in
            if (completed) {
                self?.dismiss(animated: true, completion: nil)
                AppAnalytics.shared.logEvent(name:"share_success", params:["activity":activityType ?? "nil"])
            } else {
                AppAnalytics.shared.logEvent(name:"share_decline", params:nil)
            }
            sender.isEnabled = true
            sender.alpha = 1
        }
        self.present(activityController, animated: true, completion: nil)
    }
}

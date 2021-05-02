//
//  NewsItemViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit
import WebKit
import FTLinearActivityIndicator

class WebItemViewController:UIViewController {
    
    var viewModel:WebItemViewModel!
    
    @IBOutlet var webView:WKWebView!
    @IBOutlet var loadingIndicator:FTLinearActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
        
        self.loadingIndicator.startAnimating()
        
        self.viewModel.loadContentBlock = { [weak self] content, baseURL in
            self?.webView.loadHTMLString(content, baseURL: baseURL)
        }
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = Appearance.backgroundAppColor()
        self.webView.backgroundColor = self.view.backgroundColor
    }
    
    func setupBackButton() {
        if self.webView.canGoBack {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(onBackButton(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = Appearance.topButtonTint()
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func onBackButton(_ sender:Any) {
        self.webView.goBack()
    }
    
    func presentError(error:Error) {
        let title = NSLocalizedString("Error loading this page:", comment: "")
        let message = error.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                alertController.dismiss(animated: true)
            }
        })
    }
    
    @IBAction func onShareButton(sender:UIBarButtonItem) {
        showShareActivity(sender)
    }
    
    private func showShareActivity(_ sender:UIBarButtonItem)
    {
        guard let url = viewModel.baseURL else { return }
        sender.isEnabled = false
        
        let items:[Any] = [url, viewModel.title]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.title = NSLocalizedString("Sharing a link", comment: "")
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.barButtonItem = sender
        activityController.popoverPresentationController?.backgroundColor = UIColor.lightGray
        
        activityController.completionWithItemsHandler = { [weak self] (activityType, completed, returnedItems, error) in
            if (completed) {
                self?.dismiss(animated: true, completion: nil)
                AppAnalytics.shared.logEvent(name:"share_link_success", params:["activity":activityType ?? "nil"])
            } else {
                AppAnalytics.shared.logEvent(name:"share_link_decline", params:nil)
            }
            sender.isEnabled = true
        }
        self.present(activityController, animated: true, completion: nil)
    }
}

extension WebItemViewController:WKUIDelegate {
    
    //to make some links on a page work:
    //https://nemecek.be/blog/1/how-to-open-target_blank-links-in-wkwebview-in-ios
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }

}

extension WebItemViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingIndicator.stopAnimating()
        self.setupBackButton()
        self.presentError(error: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.presentError(error: error)
        self.loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
        self.setupBackButton()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
        self.setupBackButton()
    }
}

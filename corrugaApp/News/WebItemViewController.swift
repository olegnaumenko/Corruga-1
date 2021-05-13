//
//  NewsItemViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit
import WebKit
import UniformTypeIdentifiers
import FTLinearActivityIndicator

class WebItemViewController:PresentationReportingViewController {
    
    var viewModel:WebItemViewModel!
    var previewActions = [UIPreviewAction]()
    
    private var progressTimer:Timer?
    
    @IBOutlet var webView:WKWebView!
    @IBOutlet var loadingIndicator:FTLinearActivityIndicator!
    @IBOutlet var progressIndicator:UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
        
        self.loadingIndicator.startAnimating()
        progressIndicator.progress = 0.01
        
        viewModel.loadContentBlock = { [weak self] content, baseURL in
            self?.webView.loadHTMLString(content, baseURL: baseURL)
        }
        viewModel.loadDataBlock = { [weak self] data, baseURL in
            if #available(iOS 14.0, *) {
                if let mime = UTType.webArchive.preferredMIMEType {
                    self?.webView.load(data, mimeType: mime, characterEncodingName: "utf-8", baseURL: baseURL)
                }
            }
        }
        updateUI()
        viewModel.viewDidLoad()
    }
    
    deinit {
        progressTimer?.invalidate()
    }
    
    private func updateUI() {
        self.title = self.viewModel.title
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = Appearance.backgroundAppColor()
        self.webView.backgroundColor = self.view.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupBackButton() {
    }
    
    private func updateProgressTimer() {
        if (webView.isLoading) {
            progressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
                self.updateProgress()
            })
        } else {
            progressTimer?.invalidate()
            progressTimer = nil
            updateProgress()
        }
    }
    
    private func updateProgress() {
        let progress = Float(webView.estimatedProgress)
        progressIndicator.progress = progress
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
        sender.isEnabled = false
        let url = viewModel.baseURL
        let items:[Any] = [url]
        let title = NSLocalizedString("Sharing a link", comment: "")
        showShareActivity(sender, items: items, title: title) { completed, activityType in
            sender.isEnabled = true
            if (completed) {
                AppAnalytics.shared.logEvent(name:"share_link_success", params:["activity":activityType ?? "nil"])
            } else {
                AppAnalytics.shared.logEvent(name:"share_link_decline", params:nil)
            }
        }
    }
}

extension WebItemViewController:WKUIDelegate {
    
    //to make some links on a page work:
    //https://nemecek.be/blog/1/how-to-open-target_blank-links-in-wkwebview-in-ios
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame, frame.isMainFrame {
            return nil
        }
        guard let url = navigationAction.request.url else { return nil }
        
        viewModel.navigationFromThisPage(url: url) { (title, url, error) in
            if let _ = title {
                self.updateUI()
                self.navigationController?.navigationItem.title = self.viewModel.title
            } else {
                webView.load(navigationAction.request)
            }
        }
        return nil
    }

}

extension WebItemViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingIndicator.stopAnimating()
        self.setupBackButton()
        self.presentError(error: error)
        updateProgressTimer()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.presentError(error: error)
        self.loadingIndicator.stopAnimating()
        updateProgressTimer()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
        self.setupBackButton()
        updateProgressTimer()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
        self.setupBackButton()
        updateProgressTimer()
        
        if #available(iOS 14.0, *) {
            guard let url = webView.url else { return }
            
            if (webView.estimatedProgress == 1.0) {
                webView.createWebArchiveData { [weak self] (result) in
                    self?.viewModel.loadFinished(result: result, url: url)
                }
            }
        }
    }
}

extension WebItemViewController {
    override var previewActionItems: [UIPreviewActionItem] {
        return self.previewActions
    }
}

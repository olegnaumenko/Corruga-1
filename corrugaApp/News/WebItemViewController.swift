//
//  NewsItemViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit
import WebKit

class PostStyleSchemeHandler: NSObject, WKURLSchemeHandler {
    
    func webView(_ webView: WKWebView, start startUrlSchemeTask: WKURLSchemeTask) {
        
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
//    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
//        let url = urlSchemeTask.request.url
//        let mimeType = "text/\(url?.pathExtension ?? "")" //or whatever you need
//        var response: URLResponse? = nil
//        if let url = url {
//            response = URLResponse(url: url, mimeType: mimeType, expectedContentLength: -1, textEncodingName: nil)
//        }
//        if let response = response {
//            urlSchemeTask.didReceive(response)
//        }
//        let data = getResponseData()
//        if let data = data {
//            urlSchemeTask.didReceive(data)
//        }
//        urlSchemeTask.didFinish()
//    }
}


class WebItemViewController:UIViewController {
    
    @IBOutlet var webView:WKWebView!
    
    @IBOutlet var loadingLabel:UILabel!
    
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    
    var urlString:String!
    
    var content:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var config = WKWebViewConfiguration()
//        let handler = PostStyleSchemeHandler()
//        config.setURLSchemeHandler(handler, forURLScheme: "file")
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.loadHome()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = Appearance.backgroundAppColor()
        self.webView.backgroundColor = self.view.backgroundColor
    }
    
    private func loadHome() {
        let url = URL(string: self.urlString)
        if let content = self.content {
            let baseURL = url?.deletingLastPathComponent()
            self.webView.loadHTMLString(content, baseURL: baseURL)
            
        } else {
            let request = URLRequest(url: url!)
            self.webView.load(request)
        }
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

    private func hideLoadingLabel() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingLabel?.alpha = 0
        }) { (finished) in
            self.loadingLabel?.removeFromSuperview()
        }
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
        self.loadingIndicator.isHidden = true
        self.loadingLabel?.text = "Please check connection"
        self.setupBackButton()
        self.presentError(error: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.presentError(error: error)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = true
        self.setupBackButton()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.loadingLabel?.isHidden = true;
        self.setupBackButton()
        
        self.hideLoadingLabel()
    }
}

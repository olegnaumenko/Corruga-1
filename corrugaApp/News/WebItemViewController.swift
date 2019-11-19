//
//  NewsItemViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit
import WebKit

class WebItemViewController:UIViewController {
    
    @IBOutlet var webView:WKWebView!
    
    @IBOutlet var logoLabel:UILabel?
    
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    
    var urlString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self
        self.view.backgroundColor = Appearance.backgroundAppColor()
        self.webView.backgroundColor = self.view.backgroundColor
        self.loadHome()
    }
    
    private func loadHome() {
        let url = URL(string: self.urlString)
        let request = URLRequest(url: url!)
        self.webView.load(request)
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
    
}

extension WebItemViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.setupBackButton()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
        self.setupBackButton()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.setupBackButton()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.logoLabel?.alpha = 0
        }) { (finished) in
            self.logoLabel?.removeFromSuperview()
        }
    }
}


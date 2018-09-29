//
//  NewsViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet var webView:UIWebView!
    
    @IBOutlet var loadingIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Appearance.basicAppColor()
        self.webView.backgroundColor = Appearance.basicAppColor()
        self.webView.scalesPageToFit = true
        self.webView.allowsInlineMediaPlayback = false
        self.webView.mediaPlaybackRequiresUserAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.webView.isHidden = false;
        
        let url = URL(string: "http://www.gofro.expert/novosti/")
        if (self.webView.request?.url != url!) {
            let request = URLRequest(url: url!)
            self.webView.loadRequest(request)
        }
//        self.view.addSubview(self.webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.loadHTMLString("", baseURL: nil);
//        self.webView.stopLoading()
//        self.webView.removeFromSuperview()
        self.webView.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setupBackButton() {
        if self.webView.canGoBack {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(onBackButton(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func onBackButton(_ sender:Any) {
        self.webView.goBack()
    }
    
}

extension NewsViewController:UIWebViewDelegate
{
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.setupBackButton()
    }
}

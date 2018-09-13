//
//  NewsViewController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit
import GDLoadingIndicator

class NewsViewController: UIViewController {

    @IBOutlet var webView:UIWebView!
    
    @IBOutlet var loadingIndicator:GDLoadingIndicator!// = GDLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), circleType: GDCircleType.progress, circleAnimationType: GDCircleAnimationType.running, fillerAnimationType: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Appearance.basicAppColor()
        self.webView.backgroundColor = Appearance.basicAppColor()
        self.webView.scalesPageToFit = true
        self.webView.allowsInlineMediaPlayback = false
        self.webView.mediaPlaybackRequiresUserAction = true
        let request = URLRequest(url: URL(string: "http://www.gofro.expert/novosti/")!)
        self.webView.loadRequest(request)
        
        self.loadingIndicator.setCircleColor(UIColor.white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(self.webView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.removeFromSuperview()
        self.webView.stopLoading()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsViewController:UIWebViewDelegate
{
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingIndicator.isHidden = true
    }
}

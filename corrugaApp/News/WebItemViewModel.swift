//
//  WebItemViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 01.05.2021.
//  Copyright © 2021 oleg.naumenko. All rights reserved.
//

import Foundation
import SwiftSoup

class WebItemViewModel {
    
    private let item:NewsItem
    private var htmlContent:String?
    private let source:NewsSource
    
    var loadContentBlock: (String, URL)->() = {_,_ in }
    
    private(set) var baseURL: URL?
    
    var title:String {
        return item.title
    }
    
    var titleImage:UIImage? {
        if let url = self.titleImageURL, let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    private var titleImageURL:URL?
    
    init(item:NewsItem, source:NewsSource) {
        self.item = item
        self.source = source
        self.baseURL = URL(string: item.url)
    }
    
    func viewDidLoad() {
        load()
    }
    
    func load() {
        self.source.getNewsPost(id: item.id) { (post, error) in
            if let post = post {
                let content = self.parseHtml(post: post)
                if let url = self.baseURL {
                    self.loadContentBlock(content, url.deletingLastPathComponent())
                }
            }
        }
    }
    
    
//    font: -apple-system-body
//    font: -apple-system-headline
//    font: -apple-system-subheadline
//    font: -apple-system-caption1
//    font: -apple-system-caption2
//    font: -apple-system-footnote
//    font: -apple-system-short-body
//    font: -apple-system-short-headline
//    font: -apple-system-short-subheadline
//    font: -apple-system-short-caption1
//    font: -apple-system-short-footnote
//    font: -apple-system-tall-body

    
    private func parseHtml(post:NewsOpenPost) -> String {
        let content = post.content
        let doc: Document = try! SwiftSoup.parse(content)
        print("======")

        let styleText = """
            body{font-size:36px;font-family:-apple-system;margin:38px;}
            p{text-align:justify}
            img.alignleft {float:left;margin-right:40px;margin-bottom:16px;margin-top:8px;width:48%;height:auto;}
            img.alignright{float:right;margin-left:40px;margin-bottom:16px;margin-top:8px;width:44%;height:auto;}
            img.aligncenter{float:none;}
            img.size-full,img.size-large {max-width:100%;height:auto;}
            div.fitvids-video{max-width:100%;height:auto;position:relative}
            """

        let head = doc.head()
        try! head?.appendElement("style").appendText(styleText)
        let body = doc.body()
        
        try! body?.prepend("<h2>\(post.title)</h2>")
        
        var foundTitleImage = false
        
        try! doc.select("p").forEach { (element) in
            
            var pHtml = try! element.html()
            
            pHtml = pHtml.replacingOccurrences(of: "</strong>", with: "");
            pHtml = pHtml.replacingOccurrences(of: "<strong>", with: "");
            pHtml = pHtml.replacingOccurrences(of: "&nbsp;", with: " ");

            try! element.html(pHtml)
            
//            print(try! element.html())
            
            if foundTitleImage == false {
                if let imgElement = try? element.select("img").first() {
                    if let imageURLString = try? imgElement.attr("src") {
                        self.titleImageURL = URL(string: imageURLString)
                        foundTitleImage = true
                    }
                }
            }
//            print("======")
        }
        
        let html = try! doc.html()
        print(html)
//        print("======")
        return html
    }
    
}

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
    
    private let screenScale = UIScreen.main.scale
    
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
//        print("======")

        let color = Appearance.appTintColor()
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let colorString = "rgb(\(Int(256*r)),\(Int(256*g)),\(Int(256*b)))"
        
        let fontSize = Int(18 * screenScale)
        let dateFontSize = Int(16 * screenScale)
        let bodyMargin = Int(19 * screenScale)
        let marginImgHorizontal = Int(20 * screenScale)
        let marginImgVertical = Int(4 * screenScale)
        
        
        //text-align:right;
        
        let styleText = """
            body{font-size:\(fontSize)px;font-family:-apple-system;margin:\(bodyMargin)px;}
            p{text-align:justify}
            p.date{color:\(colorString);font-size:\(dateFontSize)}
            img.alignleft{float:left;margin-right:\(marginImgHorizontal)px;
            margin-bottom:\(2 * marginImgVertical)px;margin-top:\(marginImgVertical)px;width:48%;height:auto;}
            img.alignright{float:right;margin-left:\(marginImgHorizontal)px;
            margin-bottom:\(2 * marginImgVertical)px;margin-top:\(marginImgVertical)px;width:44%;height:auto;}
            img.aligncenter{float:none;}
            img.size-full,img.size-large {max-width:100%;height:auto;}
            div.fitvids-video{max-width:100%;height:auto;position:relative}
            """

        let head = doc.head()
        try! head?.appendElement("style").appendText(styleText)
        let body = doc.body()
        
        if let date = item.date.components(separatedBy: "T").first {
            try! body?.prepend("<p class=date>􀉉 \(date)</p>")
        }
        try! body?.prepend("<h1>\(post.title)</h1>")
        
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
//        print(html)
//        print("======")
        return html
    }
    
}

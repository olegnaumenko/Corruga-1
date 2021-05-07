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
    
    private(set) var item:NewsItem
//    private var htmlContent:String?
    private let source:NewsSource
    
    var baseURL: URL? {
       return URL(string: item.url)
    }
    
    private let baseWebsiteHost = "gofro.expert"
    
    var loadContentBlock: (String, URL)->() = {_,_ in }
    
    
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
    }
    
    func viewDidLoad() {
        load()
    }
    
    func load() {
        self.source.getPostBy(id: item.id) { (post, error) in
            if let post = post {
                if let url = self.baseURL, let content = try? self.parseHtml(post: post) {
                    self.loadContentBlock(content, url.deletingLastPathComponent())
                }
            }
        }
    }
    
    func navigationFromThisPage(url:URL, completion:@escaping(String?, URL?, Error?)->()) {
        
        if url.host == baseWebsiteHost {
            let slug = url.lastPathComponent
            source.getPostBy(slug: slug) { [weak self] (post, error) in
                guard let self = self else { return }
                
                if let post = post, let url = URL(string: post.htmlURL) {
                    self.item = NewsItem(id: post.id, title: post.title, shortText: "", date: post.date, views: 0, url: url.absoluteString, imageURL: nil, adImage: nil, type: .newsType)
                    self.load()
                    completion(post.title, url, nil)
                } else {
                    completion(nil, nil, error)
                }
            }
        } else {
            completion(nil, nil, nil)
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

    
    private func parseHtml(post:NewsOpenPost) throws -> String {
        let content = post.content
        let doc: Document = try! SwiftSoup.parse(content)
//        print("======")

        let color = Appearance.appTintDespiteTheme()
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let colorString = "rgb(\(Int(256*r)),\(Int(256*g)),\(Int(256*b)))"
        
        let scale = 2
        let fontSize = Int(18 * scale)
        let dateFontSize = Int(12 * scale)
        let bodyMargin = Int(19 * scale)
        let marginImgHorizontal = Int(20 * scale)
        let marginImgVertical = Int(4 * scale)
        
        // img.size-large{max-width:100%;height:auto;}
        
        let styleText = """
            body{font-size:\(fontSize)px;font-family:-apple-system;margin:\(bodyMargin)px;}
            p{text-align:justify}
            p.date{color:\(colorString);font-size:\(dateFontSize)}
            img.size-full{width:100%;height:auto;}
            img.alignleft{float:left;margin-right:\(marginImgHorizontal)px;
            margin-bottom:\(2 * marginImgVertical)px;margin-top:\(marginImgVertical)px;width:48%;height:auto;}
            img.alignright{float:right;margin-left:\(marginImgHorizontal)px;
            margin-bottom:\(2 * marginImgVertical)px;margin-top:\(marginImgVertical)px;width:44%;height:auto;}
            img.aligncenter{float:none;}
            div.fitvids-video{max-width:100%;height:auto;position:relative}
            iframe{width:100%;}
            figure.aligncenter{width:100%;height:auto;margin:0px}
            figcaption{font-size:\(fontSize - 2)px;text-align:center;color:gray}
            """

        let head = doc.head()
        try head?.appendElement("style").appendText(styleText)
        let body = doc.body()
        
        if let date = item.date.components(separatedBy: "T").first {
            try body?.prepend("<p class=date>􀉉 \(date)</p>")
        }
        try body?.prepend("<h2>\(post.title)</h2>")
        
        var foundTitleImage = false
        
        try doc.select("p").forEach { (element) in
            
            var pHtml = try element.html()
            
            pHtml = pHtml.replacingOccurrences(of: "</strong>", with: "").replacingOccurrences(of: "<strong>", with: "").replacingOccurrences(of: "&nbsp;", with: " ");

            try element.html(pHtml)
            
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
        
        try? doc.select("figure").forEach { (element) in
            try element.removeAttr("style")
        }
        try? doc.select("iframe").forEach { (element) in
           
//            let src = try element.attr("src")
//            let components = src.components(separatedBy: "&url=")
//            if components.count > 1 {
//                let href = components[1]
//                if (!href.isEmpty) {
//                    try element.attr("src", href)
//                }
//            }
            try element.attr("style", "width=100%;height:600px;")
            
        }
        
        let html = try! doc.html()
//        print(html)
//        print("======")
        return html
    }
    
}

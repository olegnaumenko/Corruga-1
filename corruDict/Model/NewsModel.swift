//
//  NewsModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

//struct NewsItem {
//    let title:String
//    let shortText:String
//    let date:Date
//    let views:Int
//}

class NewsModel {
    
    //    let newsURLString = "https://novosti.gofro.expert/novosti/"
    let newsURLString = "https://novosti.gofro.expert/wp-json/wp/v2/posts"
    
    static let shared = NewsModel()
    
    var newsItems = [NewsItem]()
}

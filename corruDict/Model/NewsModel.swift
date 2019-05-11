//
//  NewsModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/11/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

struct NewsItem {
    let title:String
    let shortText:String
    let date:Date
    let views:Int
}

class NewsModel {
    
    static let shared = NewsModel()
    
    var newsItems = [NewsItem]()
}

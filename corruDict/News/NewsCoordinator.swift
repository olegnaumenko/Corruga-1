//
//  NewsCoordinator.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import UIKit

class NewsCoordinator: NSObject {
    
    let newsViewController:NewsViewController
    init(newsViewController:NewsViewController) {
        self.newsViewController = newsViewController
        super.init()
    }
}

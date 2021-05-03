//
//  RootTabBarController.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/6/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

class AppTabBarController: UITabBarController {
    
    override func awakeFromNib() {
        let titles = ["tab-bar-news-title",
                      "tab-bar-video-title",
                      "tab-bar-dictionary-title",
                      "tab-bar-board-title"]
        for i in 0..<titles.count {
            if let nvc = self.viewControllers?[i] as? UINavigationController {
                nvc.title = titles[i].n10
                nvc.topViewController?.title = nvc.title
            }
        }
    }
    
}

//
//  UIStoryboard+Main.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/31/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit


extension UIStoryboard {
    static let kMainStoryboardName = "Main"
    static var main:UIStoryboard {
        return UIStoryboard(name: kMainStoryboardName, bundle: nil)
    }
    
    static func detailViewController() -> DetailViewController {
        return self.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    }
    
    static func photoViewController() -> PhotoViewController {
        return self.main.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
    }
    
    static func shareViewController() -> ShareViewController {
        return self.main.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
    }
}

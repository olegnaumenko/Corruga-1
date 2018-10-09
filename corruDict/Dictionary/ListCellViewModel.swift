//
//  ListCellViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 9/4/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import UIKit

struct ListCellViewModel {
    
    var title = NSAttributedString(string: "")
    var subtitle = ""
    var searchTerm = ""
    var backgroundColor = UIColor.white
    
    init(entry:TranslationEntity, translation:TranslationEntity?, index:Int, searchTerm:String) {
        
        let range = (entry.stringValue as NSString).range(of: searchTerm)
        
        let attrString = NSMutableAttributedString(string: entry.stringValue)
        let attrs = [NSBackgroundColorAttributeName : Appearance.highlightedTextColor()]
        attrString.setAttributes(attrs, range: range)
        
        title = attrString
        subtitle = translation?.stringValue ?? ""
        backgroundColor = Appearance.cellColor(even: (Int(index % 2) == 0))
    }
}

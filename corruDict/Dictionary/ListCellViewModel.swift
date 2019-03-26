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
        let attrs = [convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor) : Appearance.highlightedTextColor()]
        attrString.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(attrs), range: range)
        
        title = attrString
        subtitle = translation?.stringValue ?? ""
        backgroundColor = Appearance.cellColor(even: (Int(index % 2) == 0))
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

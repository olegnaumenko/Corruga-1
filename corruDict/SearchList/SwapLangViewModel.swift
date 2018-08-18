//
//  SwapLangViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

struct SwapLangViewModel {
    
    private let dict:DictModel
    private let text:String
    private let langID:String
    
    init(dict:DictModel, text:String, langID:String) {
        self.dict = dict
        self.text = text
        self.langID = langID
    }
    
    var shouldSwap:Bool {
        get {
            if text.count == 0,
                let range = self.dict.toStorage.languageID.range(of: langID.substring(to: String.Index(encodedOffset: 1))) {
                let bound = range.lowerBound
                return bound == langID.startIndex
            }
            return false
        }
    }
}

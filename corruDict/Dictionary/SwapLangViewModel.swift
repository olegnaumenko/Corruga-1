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
            let index = langID.index(langID.startIndex, offsetBy: 1)
            if let range = self.dict.toStorage.languageID.range(of: langID[...index]) {
                let bound = range.lowerBound
                return bound == langID.startIndex
            }
            return false
        }
    }
}

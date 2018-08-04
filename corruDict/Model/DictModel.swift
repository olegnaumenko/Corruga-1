//
//  DictModel.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class DictModel {

    var fromStorage:LanguageStorage
    var toStorage:LanguageStorage
    
    init(fromID:String, toID:String) {
        fromStorage = LanguageStorage(fileName: fromID)
        toStorage = LanguageStorage(fileName: toID)
    }
    
    func swapLanguages()
    {
        let fromStorage = self.fromStorage
        let toStorage = self.toStorage
        self.fromStorage = toStorage
        self.toStorage = fromStorage
        
//        print(self.toStorage.languageID)
//        print(self.fromStorage.languageID)
    }
    
    func languagesLabel() -> String {
        
        if let fromLang = self.fromStorage.languageID.components(separatedBy: "_").first,
            let toLang = self.toStorage.languageID.components(separatedBy: "_").first
        {
            return "\(fromLang.uppercased()) <-> \(toLang.uppercased())"
        }
        
        return "XX <-> YY"
    }
}

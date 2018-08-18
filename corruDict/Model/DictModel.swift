//
//  DictModel.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class DictModel {

    var fromStorage:LanguageStorage
    var toStorage:LanguageStorage
    
    var fromLanguageID: String {
        get {
            return fromStorage.languageID
        }
    }
    
    var toLanguageID: String {
        get {
            return toStorage.languageID
        }
    }
    
    var searchResults:Results<TranslationEntity>? {
        didSet {
            self.onDictResultsChanged()
        }
    }
    
    var onDictResultsChanged = {}
    var onDictLanguagesSwapped:(()->())?
    
    var currentSearchTerm:String = "" {
        didSet {
            if (currentSearchTerm == "") {
                self.searchResults = self.fromStorage.allTranslationEntities()
            } else {
                self.searchResults = self.fromStorage.searchForTerms(term: currentSearchTerm)
            }
        }
    }
    
    init(fromID:String, toID:String) {
        fromStorage = LanguageStorage(fileName: fromID)
        toStorage = LanguageStorage(fileName: toID)
    }
    
    func swapLanguages() {
        let fromStorage = self.fromStorage
        let toStorage = self.toStorage
        self.fromStorage = toStorage
        self.toStorage = fromStorage
        
        self.onDictLanguagesSwapped?()
        
//        print(self.toStorage.languageID)
//        print(self.fromStorage.languageID)
    }
    
//    func languagesLabel() -> String {
//        if let fromLang = self.fromStorage.languageID.components(separatedBy: "_").first,
//            let toLang = self.toStorage.languageID.components(separatedBy: "_").first
//        {
//            return "\(fromLang.uppercased()) <-> \(toLang.uppercased())"
//        }
//        
//        return "XX <-> YY"
//    }
}

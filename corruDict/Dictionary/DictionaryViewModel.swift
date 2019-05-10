//
//  DictionaryViewModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/10/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit

class DictionaryViewModel {
    
    var dictModel:DictModel
    
    var onDidSearch:(String, Bool)->() = { searchTerm, shouldScrollToTop in }
    var onDidChangeLanguages:()->() = {}
    var searchTerm:String {
        get {
            return self.dictModel.currentSearchTerm
        }
    }
    
    var oldCount = 0
    
    init(dictModel:DictModel) {
        self.dictModel = dictModel
        
        dictModel.onDictLanguagesChanged = { [weak self] in
            self?.onDidChangeLanguages()
        }
        
        dictModel.onDictResultsChanged = { [weak self] in
            if let cSearchTerm = self?.dictModel.currentSearchTerm, let oCount = self?.oldCount {
                self?.onDidSearch(cSearchTerm, oCount > cSearchTerm.count)
            }
        }
            
        self.search(term: Settings.s.searchTerm)
    }
    
    func search(term:String) {
        oldCount = self.dictModel.currentSearchTerm.count
        self.dictModel.currentSearchTerm = term
        Settings.s.searchTerm = term
    }
    
    func clearSearch() {
        let term = ""
        oldCount = self.dictModel.currentSearchTerm.count
        self.dictModel.currentSearchTerm = term
        Settings.s.searchTerm = term
    }

    func footerTotal() -> String {
        return TotalLabelViewModel(total: self.dictModel.searchResults?.count ?? 0).output
    }
    
    func fromLanguageLabel() -> String {
        return self.dictModel.fromLangModel.languageID.components(separatedBy: "_").first?.uppercased() ?? "XX"
    }
    
    
    func toLanguageLabel() -> String {
        return self.dictModel.toLangModel.languageID.components(separatedBy: "_").first?.uppercased() ?? "YY"
    }
    
    var fromLangId:String {
        return self.dictModel.fromLanguageID
    }
    
    var toLangId:String {
        return self.dictModel.toLanguageID
    }
    
    
    func swapLanguages(reSearch:Bool) {
        self.dictModel.swapLanguages()
        Settings.s.setLanguages(from: self.dictModel.fromLanguageID, to: self.dictModel.toLanguageID)
        if (reSearch) {
            self.search(term: self.dictModel.currentSearchTerm)
        } else {
            self.clearSearch()
        }
        AppAnalytics.shared.logEvent(name: "swap_lang", params: ["to_lang" : self.dictModel.toLanguageID])
    }
    
    func inputModeChange(locale:String, text:String) {
        if SwapLangViewModel(dict: self.dictModel, langID: locale).shouldSwap {
            self.swapLanguages(reSearch: false)
        }
    }
    
    func setFromLangId(_ langId:String) {
        self.dictModel.setFromLangId(langId)
        Settings.s.setLanguages(from: self.dictModel.fromLanguageID, to: self.dictModel.toLanguageID)
        self.clearSearch()
    }
    
    func setToLangId(_ langId:String) {
        self.dictModel.setToLangId(langId)
        Settings.s.setLanguages(from: self.dictModel.fromLanguageID, to: self.dictModel.toLanguageID)
        self.clearSearch()
    }
}

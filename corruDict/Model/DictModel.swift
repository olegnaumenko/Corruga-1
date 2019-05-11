//
//  DictModel.swift
//  corruDict
//
//  Created by oleg.naumenko on 7/25/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
//import RealmSwift
import Firebase



class DictModel {

    
    static let shared = DictModel(fromID: Settings.s.fromLangID, toID: Settings.s.toLangID)
    
    var fromLangModel:LanguageModel! {
        didSet {
            fromLangModel.delegate = self
        }
    }
    var toLangModel:LanguageModel! {
        didSet {
            toLangModel.delegate = self
        }
    }
    
    var fromLanguageID: String {
        get {
            return fromLangModel.languageID
        }
    }
    
    var toLanguageID: String {
        get {
            return toLangModel.languageID
        }
    }
    
    var searchResults:[TranslationEntryModel]? {
        didSet {
            self.onDictResultsChanged()
        }
    }
    
    var onDictResultsChanged = {}
    var onDictLanguagesChanged = {}
    
    var currentSearchTerm:String = "" {
        didSet {
           self.update()
        }
    }
    
    private func update() {
        if (currentSearchTerm == "") {
            self.fromLangModel.allTranslationEntities() { translationEntityModels in
                self.searchResults = translationEntityModels
            }
        } else {
            self.fromLangModel.searchFor(term: currentSearchTerm,
                                         completion: { (translationEntityModels) in
                                            self.searchResults = translationEntityModels
            })
        }
    }
    
    private init(fromID:String, toID:String) {
        Database.database().isPersistenceEnabled = true
        setLanguages(fromID: fromID, toID: toID)
    }
    
    
    private func setLanguages(fromID:String, toID:String) {
        assert(fromID != toID)
        fromLangModel = LanguageModel(languageID: fromID)
        toLangModel = LanguageModel(languageID: toID)
    }
    
    private func complementaryLangIds(for langId:String) -> [String] {
        return Settings.s.availableLangIDs.filter({ (everyLangId) -> Bool in
            return everyLangId != langId
        })
    }
    
    func setup() {}
    
    func setFromLangId(_ fromId:String) {
        let complIds = self.complementaryLangIds(for: fromId)
        if complIds.contains(self.toLanguageID) == false, let toId = complIds.first {
            toLangModel = LanguageModel(languageID: toId)
        }
        fromLangModel = LanguageModel(languageID: fromId)
        onDictLanguagesChanged()
    }
    
    func setToLangId(_ toId:String) {
        let complIds = self.complementaryLangIds(for: toId)
        if complIds.contains(self.fromLanguageID) == false, let fromId = complIds.first {
            fromLangModel = LanguageModel(languageID: fromId)
        }
        toLangModel = LanguageModel(languageID: toId)
        onDictLanguagesChanged()
    }
    
    func swapLanguages() {
        let fromTemp = fromLangModel
        let toTemp = toLangModel
        fromLangModel = toTemp
        toLangModel = fromTemp
        onDictLanguagesChanged()
    }
}


extension DictModel:LanguageModelDelegate {
    func langModelDidChange(_ langmodel: LanguageModel) {
        self.update()
    }
}

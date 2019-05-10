//
//  LanguageModel.swift
//  Corruga
//
//  Created by oleg.naumenko on 5/8/19.
//  Copyright © 2019 oleg.naumenko. All rights reserved.
//

import UIKit
import Firebase

struct TranslationEntryModel {
    let id:Int
    let transcription:String
    let value:String
    
    init(id:Int, transcription:String?, value:String?) {
        self.id = id
        self.transcription = transcription ?? "<unknown>"
        self.value = value ?? "<unknown>"
    }
    
    init() {
        id = 0
        transcription = "<unknown>"
        value = "<unknown>"
    }
}

protocol LanguageModelDelegate:class {
    func langModelDidChange(_ langmodel:LanguageModel)
}

class LanguageModel {

    static func longName(langId:String) -> String {
        switch langId {
        case "en_US":
            return "English"
        case "ru_RU":
            return "Russian"
        case "ch_CH":
            return "Chinese"
        default:
            return ""
        }
    }
    
    static func longNativeName(langId:String) -> String {
        switch langId {
        case "en_US":
            return "English"
        case "ru_RU":
            return "Русский"
        case "ch_CH":
            return "Chinese"
        default:
            return ""
        }
    }
    
    private (set) var languageID:String
    
    private var entryModels = [TranslationEntryModel]()
    private var ref:DatabaseReference!
    
    weak var delegate:LanguageModelDelegate?
    
    init(languageID:String) {
        self.languageID = languageID
        ref = Database.database().reference(withPath: languageID)
        read()
    }
    
    deinit {
        ref.removeAllObservers()
    }
    
    var currentIndex = 0
    
    func read() {
        self.ref.queryOrdered(byChild: "id").observeSingleEvent(of: .value, with: { (dataSnapshot) in
 
            if let langEntriesArray = dataSnapshot.value as? [AnyObject] {
                var entries = [TranslationEntryModel]()
                entries.reserveCapacity(langEntriesArray.count)
                
                for dictionary in langEntriesArray {
                    entries.append(TranslationEntryModel(id: dictionary["id"] as! Int,
                                                                  transcription: dictionary["transcription"] as? String,
                                                                  value: dictionary["value"] as? String))
                }
                self.entryModels = entries
                self.delegate?.langModelDidChange(self)
            }
        })
    }
    
    
    func allTranslationEntities(completion:@escaping ([TranslationEntryModel])->())
    {
        completion(self.entryModels)
    }
    

    func searchFor(term:String, completion:@escaping ([TranslationEntryModel])->())
    {
        let searchResults = self.entryModels.filter { (entryModel) -> Bool in
            return entryModel.value.contains(term)
        }
        completion(searchResults)
    }
    
    
    func translation(withID termID:Int, completion:@escaping (TranslationEntryModel?, Error?)->())
    {
        let entryModel = self.entryModels.first { (translatedEntryModel) -> Bool in
            translatedEntryModel.id == termID
        }
        completion(entryModel, nil)
    }
}

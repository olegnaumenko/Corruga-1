//
//  Settings.swift
//  Corruga
//
//  Created by oleg.naumenko on 8/18/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation

class Settings
{
    private let defaults = UserDefaults.standard
    
    //keys
    private let kSearchTermKey  = "CurrentSearchTerm"
    private let kFromLanguageID = "FromLanguageID"
    private let kToLanguageID   = "ToLanguageID"
    
    
    //default values
    private let kDefaultSearchTerm  = ""
    private let kDefaultFromLangID  = "en_US"
    private let kDefaultToLangID    = "ru_RU"
    
    
    static var s:Settings = Settings()
    
    private init() {
        defaults.register(defaults: [kSearchTermKey : kDefaultSearchTerm])
    }
    
    var searchTerm:String {
        get {
            return (defaults.object(forKey: kSearchTermKey) as? String) ?? kDefaultSearchTerm
        }
        set {
            defaults.setValue(newValue, forKey: kSearchTermKey)
        }
    }
    
    var fromLangID:String {
        get {
            return (defaults.object(forKey: kFromLanguageID) as? String) ?? kDefaultFromLangID
        }
    }
    
    var toLangID:String {
        get {
            return (defaults.object(forKey: kToLanguageID) as? String) ?? kDefaultToLangID
        }
    }
    
    func setLanguages(from:String, to:String) {
        assert(from != to)
        defaults.setValue(from, forKey: kFromLanguageID)
        defaults.setValue(to,   forKey: kToLanguageID)
    }
    
}

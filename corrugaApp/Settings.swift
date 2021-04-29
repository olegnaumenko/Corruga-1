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
    static let s:Settings = Settings()
    
    private let defaults = UserDefaults.standard
    
    //keys
    
    enum Keys:String {
        case searchTerm = "CurrentSearchTerm"
        case fromLangID = "FromLanguageID"
        case   toLangID = "ToLanguageID"
        case newsLastDate = "NewsLastDate"
        case boardLastDate = "BoardLastDate"
        case videoLastDate = "VideoLastDate"
        
        var key:String {
            return self.rawValue
        }
    }
    
    //default values
    private let kDefaultSearchTerm  = ""
    
    //all lang ids:
    let availableLangIDs = ["en-US", "zh-CN", "ru-RU"]
    
    private init() {
        
        //to migrate from older app versions:
        
        if self.fromLangID.contains("_") || self.toLangID.contains("_") {
            self.setLanguages(from: self.fromLangID.replacingOccurrences(of: "_", with: "-"), to: self.toLangID.replacingOccurrences(of: "_", with: "-"))
        }
        
        if self.fromLangID == "ch_CH" || self.fromLangID == "ch-CH" {
            setLanguages(from: "zh-CN", to: self.toLangID)
        }
        
        if self.toLangID == "ch_CH" || self.toLangID == "ch-CH" {
            setLanguages(from: self.fromLangID, to: "zh-CN")
        }
        
        //end of version migration
        
        assert(availableLangIDs.count > 1)//for default fromLangID and toLandID:
        defaults.register(defaults: [Keys.searchTerm.key : kDefaultSearchTerm,
                                     Keys.fromLangID.key : availableLangIDs[0],
                                     Keys.toLangID.key : availableLangIDs[1]])
    }
    
    var newsLastUpdateDate:String? {
        get {
            return (defaults.object(forKey: Keys.newsLastDate.key) as? String)
        } set {
            defaults.setValue(newValue, forKey: Keys.newsLastDate.key)
        }
    }
    
    var boardLastUpdateDate:String? {
        get {
            return (defaults.object(forKey: Keys.boardLastDate.key) as? String)
        } set {
            defaults.setValue(newValue, forKey: Keys.boardLastDate.key)
        }
    }
    
    var videoLastUpdateDate:String? {
        get {
            return (defaults.object(forKey: Keys.videoLastDate.key) as? String)
        } set {
            defaults.setValue(newValue, forKey: Keys.videoLastDate.key)
        }
    }
    
    var searchTerm:String {
        get {
            return (defaults.object(forKey: Keys.searchTerm.key) as? String) ?? kDefaultSearchTerm
        } set {
            defaults.setValue(newValue, forKey: Keys.searchTerm.key)
        }
    }
    
    var fromLangID:String { get {
            return (defaults.object(forKey: Keys.fromLangID.key) as? String) ?? availableLangIDs[0]
        }
    }
    
    var toLangID:String { get {
            return (defaults.object(forKey: Keys.toLangID.key) as? String) ?? availableLangIDs[1]
        }
    }
    
    func setLanguages(from:String, to:String) {
        assert(from != to)
        defaults.setValue(from, forKey: Keys.fromLangID.key)
        defaults.setValue(to,   forKey: Keys.toLangID.key)
    }
}

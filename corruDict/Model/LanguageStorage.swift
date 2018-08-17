//
//  Storage.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class LanguageStorage
{
    var languageID:String
    var realm:Realm
    
    static let realmExtension = "realm"
    static let realmDirectory = "data"
    
    init(fileName:String) {
        
        self.languageID = fileName
        
        let url = Bundle.main.url(forResource: fileName,
                                  withExtension: LanguageStorage.realmExtension,
                                  subdirectory: LanguageStorage.realmDirectory)
        
        let config = Realm.Configuration.init(fileURL: url, inMemoryIdentifier: nil,
                                              syncConfiguration: nil,
                                              encryptionKey: nil,
                                              readOnly: true,
                                              schemaVersion: 0,
                                              migrationBlock: nil,
                                              deleteRealmIfMigrationNeeded: false,
                                              shouldCompactOnLaunch: nil,
                                              objectTypes: nil)
        self.realm = try! Realm(configuration: config)
    }
    
    init(languageID:String) {
        self.languageID = languageID
        
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            let realmDirURL = fileURL.deletingLastPathComponent()
            let newFileURL = realmDirURL.appendingPathComponent(languageID).appendingPathExtension(LanguageStorage.realmExtension)
            let config = Realm.Configuration.init(fileURL: newFileURL, inMemoryIdentifier: nil,
                                                  syncConfiguration: nil, encryptionKey: nil,
                                                  readOnly: false, schemaVersion: 0,
                                                  migrationBlock: nil, deleteRealmIfMigrationNeeded: true,
                                                  shouldCompactOnLaunch: nil, objectTypes: nil)
            
            self.realm = try! Realm(configuration: config)
        } else {
            fatalError()
        }
    }
    
    var currentIndex = 0
    
    func clearStorage()
    {
        autoreleasepool {
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
                print("error deleting realm files!")
            }
        }
        currentIndex = 0
    }
    
    //'TranslationEntity' does not have a primary key and can not be updated
    func addOrUpdateTranslation(termID:String, stringValue:String)
    {
        try! realm.write {
            realm.create(TranslationEntity.self, value: [currentIndex, termID, stringValue, self.languageID], update: false)
            currentIndex += 1
        }
    }
    
    func allTranslationEntities() -> Results<TranslationEntity>
    {
        return realm.objects(TranslationEntity.self).sorted(byKeyPath: "stringValue", ascending: true)
    }
    
    func allEntities<S:Object>() -> Results<S>?
    {
        return (realm.objects(S.self))
    }
    
    func searchForTerms(term:String) -> Results<TranslationEntity>
    {
        let predicate = NSPredicate(format: "stringValue CONTAINS[c] %@", term)
        return realm.objects(TranslationEntity.self).filter(predicate)
    }
    
    func translation(withID termID:String) -> TranslationEntity?
    {
        let objects = realm.objects(TranslationEntity.self)
            
        return objects.filter("termID == \"\(termID)\"").first
    }
    
    func reassignIndexesAlphabetically() {
        
        var index = 0
        let objects = realm.objects(TranslationEntity.self).sorted(byKeyPath: "stringValue", ascending: true)
        
        try! realm.write {
            objects.forEach { (translation) in
                translation.index = index;
                index += 1
            }
        }
    }
    
    func saveFile(name:String)
    {
        if let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        {
            var url = URL(fileURLWithPath: path)
            url.appendPathComponent(name)
            url.appendPathExtension("realm")
            
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("error deleting realm file!")
            }
            
            do {
                try realm.writeCopy(toFile: url)
                print("file saved")
            } catch {
                print("error saving realm file!")
            }
        }
    }
}

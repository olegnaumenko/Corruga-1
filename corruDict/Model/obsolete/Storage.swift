//
//  Storage.swift
//  corruConverter
//
//  Created by oleg.naumenko on 7/26/18.
//  Copyright © 2018 oleg.naumenko. All rights reserved.
//

import Foundation
import RealmSwift

class Storage
{
    var realm:Realm?
    var locale:String!
    
    init(fileName:String) {
        
        self.locale = fileName
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "realm")
        
        let config = Realm.Configuration.init(fileURL: url, inMemoryIdentifier: nil,
                                              syncConfiguration: nil,
                                              encryptionKey: nil,
                                              readOnly: true,
                                              schemaVersion: 0,
                                              migrationBlock: nil,
                                              deleteRealmIfMigrationNeeded: false,
                                              shouldCompactOnLaunch: nil,
                                              objectTypes: [Entry.self])
        self.realm = try! Realm(configuration: config)
    }
    
    var currentPrimaryId = 0
    
    func clearStorage()
    {
        autoreleasepool {
            try! self.realm?.write {
                self.realm?.deleteAll()
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
        currentPrimaryId = 0
    }
    
    func addOrUpdateEntry(id:String, entry:String, translation:String)
    {
        try! realm?.write {
            realm?.create(Entry.self, value: [currentPrimaryId, id, entry, translation], update: true)
            currentPrimaryId += 1
        }
    }
    
    func allEntries() -> Results<Entry>?
    {
        return realm?.objects(Entry.self)
    }
    
    func searchForTerms(term:String) -> Results<Entry>?
    {
        let predicate = NSPredicate(format: "entry CONTAINS[c] %@", term)
        return realm?.objects(Entry.self).filter(predicate)
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
                try realm?.writeCopy(toFile: url)
                print("file saved")
            } catch {
                print("error saving realm file!")
            }
        }
    }
}
